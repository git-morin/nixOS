{ pkgs, lib, ... }:
{
  home.file."bin/b2bid-sync" = lib.mkIf pkgs.stdenv.isDarwin {
    executable = true;
    text = ''
      #!/usr/bin/env -S uv run --script
      # /// script
      # requires-python = ">=3.12"
      # ///
      """Pull changes on all active b2b-identity GitLab repos.

      Fetches non-archived projects from the b2b-identity group (including
      subgroups) and runs `git pull --ff-only` on each local clone.

      Usage:
          b2bid-sync
      """

      import json
      import os
      import shutil
      import subprocess
      from concurrent.futures import ThreadPoolExecutor, as_completed
      from datetime import date, timedelta
      from pathlib import Path
      from urllib.error import URLError
      from urllib.request import Request, urlopen

      GROUP: str = "b2b-identity"
      LOCAL_ROOT: Path = Path.home() / GROUP
      ABANDON_CUTOFF: str = (date.today() - timedelta(days=365 * 2)).isoformat()


      def fetch_projects(base_url: str, token: str) -> list[dict]:
          """Fetch all projects from the group including subgroups."""
          projects: list[dict] = []
          page = 1
          while True:
              url = (
                  f"https://{base_url}/api/v4/groups/{GROUP}/projects"
                  f"?include_subgroups=true&per_page=100&page={page}"
              )
              req = Request(
                  url,
                  headers={
                      "PRIVATE-TOKEN": token,
                      "User-Agent": "b2bid-sync/1.0",
                  },
              )
              try:
                  with urlopen(req, timeout=15) as resp:
                      data = json.loads(resp.read())
              except URLError as e:
                  raise SystemExit(f"API error: {e}") from e

              if not data:
                  break
              projects.extend(data)
              if len(data) < 100:
                  break
              page += 1
          return projects


      def local_path(project: dict) -> Path:
          """Derive local clone path from project namespace."""
          ns: str = project["path_with_namespace"]
          relative = ns.removeprefix(f"{GROUP}/")
          return LOCAL_ROOT / relative


      def _warn_message(stderr: str) -> str:
          """Summarize a stale-local-state git error into a short warning."""
          if "no tracking information" in stderr:
              return "no upstream tracking branch"
          if "no such ref" in stderr:
              return "tracking branch deleted on remote"
          if "Not possible to fast-forward" in stderr or "diverged" in stderr.lower():
              return "local branch diverged from remote"
          return stderr.split("\n")[0]


      def pull(project: dict) -> tuple[str, str, str]:
          """Fetch and fast-forward the local clone. Returns (name, status, detail)."""
          archived = project.get("archived", False)
          abandoned = project.get("last_activity_at", "")[:10] < ABANDON_CUTOFF
          path = local_path(project)
          name: str = project["path_with_namespace"].removeprefix(f"{GROUP}/")

          if archived or abandoned:
              reason = "archived" if archived else "abandoned"
              if path.exists():
                  shutil.rmtree(path)
                  return name, "deleted", reason
              return name, "skip", reason

          if not (path / ".git").exists():
              return name, "skip", "not cloned locally"

          # Fetch and prune stale remote-tracking refs
          subprocess.run(
              ["git", "fetch", "origin", "--prune", "--quiet"],
              cwd=path,
              capture_output=True,
              text=True,
          )

          result = subprocess.run(
              ["git", "merge", "--ff-only", "@{u}"],
              cwd=path,
              capture_output=True,
              text=True,
          )
          if result.returncode == 0:
              return name, "ok", result.stdout.strip() or "already up to date"

          stderr = result.stderr.strip()
          # Stale local state is expected in a dev workspace — warn, don't error
          if any(phrase in stderr for phrase in [
              "no tracking information",
              "no such ref",
              "Not possible to fast-forward",
              "diverged",
          ]):
              return name, "warn", _warn_message(stderr)

          return name, "error", stderr or result.stdout.strip()


      def main() -> None:
          """Entry point for b2bid-sync."""
          base_url: str = os.environ.get("GITLAB_BASE_URL", "")
          token: str = os.environ.get("GITLAB_TOKEN", "")
          if not base_url or not token:
              raise SystemExit(
                  "GITLAB_BASE_URL and GITLAB_TOKEN must be set. "
                  "Run `rebuild` to apply secrets from SOPS."
              )

          print(f"Fetching active projects from {GROUP}...")
          projects = fetch_projects(base_url, token)
          print(f"Found {len(projects)} active projects. Pulling...\n")

          results: list[tuple[str, str, str]] = []
          with ThreadPoolExecutor(max_workers=8) as pool:
              futures = {pool.submit(pull, p): p for p in projects}
              for future in as_completed(futures):
                  name, status, detail = future.result()
                  results.append((name, status, detail))
                  sym = {"ok": "✓", "skip": "·", "deleted": "🗑", "warn": "⚠", "error": "✗"}.get(status, "?")
                  print(f"  {sym} {name}: {detail}")

          ok = sum(1 for _, s, _ in results if s == "ok")
          skipped = sum(1 for _, s, _ in results if s == "skip")
          deleted = sum(1 for _, s, _ in results if s == "deleted")
          warnings = [(n, d) for n, s, d in results if s == "warn"]
          errors = [(n, d) for n, s, d in results if s == "error"]

          print(f"\n{ok} pulled, {deleted} deleted, {skipped} skipped, {len(warnings)} warnings, {len(errors)} errors")
          if warnings:
              print("\nWarnings (stale local state — needs manual attention):")
              for name, detail in warnings:
                  print(f"  {name}: {detail}")
          if errors:
              print("\nErrors:")
              for name, detail in errors:
                  print(f"  {name}: {detail}")


      if __name__ == "__main__":
          main()
    '';
  };
}
