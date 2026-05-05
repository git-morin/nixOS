{ pkgs, ... }:
let
  noTodoScript = pkgs.writeShellScript "prek-no-todo" ''
    set -euo pipefail

    # Only fail if a staged hunk introduces a "TODO:" line.
    # Args are matched filenames passed by prek.
    failed=0
    for file in "$@"; do
      diff=$(git diff --cached --unified=0 -- "$file" || true)
      hits=$(printf '%s\n' "$diff" \
        | ${pkgs.gnugrep}/bin/grep -nE '^\+[^+].*TODO:' || true)
      if [ -n "$hits" ]; then
        echo "TODO: found in staged hunks of $file" >&2
        printf '%s\n' "$hits" >&2
        failed=1
      fi
    done
    exit "$failed"
  '';
in
{
  programs.prek = {
    enable = true;

    localHooks = [
      {
        id = "no-todo";
        name = "Block 'TODO:' in staged hunks";
        entry = toString noTodoScript;
        language = "system";
        types = [ "text" ];
        pass_filenames = true;
      }
    ];
  };
}
