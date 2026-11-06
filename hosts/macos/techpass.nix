{ primaryUser, lib, pkgs, ... }:
let
  app = "/Applications/Tech Pass.app";
  assetsUrl = "https://REDACTED_URL";
in
{
  # Tech Pass v6 ships as a DMG and updates itself, so nix only installs it once.
  system.activationScripts.postActivation.text = lib.mkOrder 1750 ''
    techpass_install() {
      local tmp url sha
      tmp="$(/usr/bin/mktemp -d)"
      if ! /usr/bin/curl -fsSL -m 60 "${assetsUrl}" -o "$tmp/assets.json"; then
        echo >&2 "techpass: WARNING could not fetch ${assetsUrl} (VPN?); skipping install"
        /bin/rm -rf "$tmp"; return 0
      fi
      url="$(${pkgs.jq}/bin/jq -r '.[] | select(.name | endswith("_universal.dmg")) | .url' "$tmp/assets.json" | /usr/bin/sed 's/ /%20/g')"
      sha="$(${pkgs.jq}/bin/jq -r '.[] | select(.name | endswith("_universal.dmg")) | .sha256' "$tmp/assets.json")"
      if [ -z "$url" ] || [ -z "$sha" ]; then
        echo >&2 "techpass: WARNING no universal DMG in assets.json; skipping install"
        /bin/rm -rf "$tmp"; return 0
      fi

      echo >&2 "techpass: downloading $url"
      if ! /usr/bin/curl -fsSL --retry 2 -m 600 "$url" -o "$tmp/techpass.dmg"; then
        echo >&2 "techpass: WARNING download failed; skipping install"
        /bin/rm -rf "$tmp"; return 0
      fi
      if [ "$(/usr/bin/shasum -a 256 "$tmp/techpass.dmg" | /usr/bin/cut -d' ' -f1)" != "$sha" ]; then
        echo >&2 "techpass: ERROR sha256 mismatch; skipping install"
        /bin/rm -rf "$tmp"; return 0
      fi

      /bin/mkdir -p "$tmp/mnt"
      if /usr/bin/hdiutil attach -nobrowse -readonly -quiet -mountpoint "$tmp/mnt" "$tmp/techpass.dmg"; then
        /usr/bin/ditto "$tmp/mnt/Tech Pass.app" "${app}" || echo >&2 "techpass: ERROR copy failed"
        /usr/bin/hdiutil detach -quiet "$tmp/mnt" || true
      else
        echo >&2 "techpass: ERROR could not mount DMG"
      fi
      /bin/rm -rf "$tmp"

      if [ -d "${app}" ]; then
        # The in-app updater runs as the user and replaces the bundle.
        /usr/sbin/chown -R ${primaryUser}:staff "${app}"
        /usr/bin/xattr -cr "${app}"
        echo >&2 "techpass: installed $("${app}/Contents/MacOS/tech-pass" version 2>/dev/null)"
      fi
    }

    if [ ! -d "${app}" ]; then
      echo >&2 "techpass: ${app} missing, installing latest stable..."
      techpass_install
    fi

    if [ -x "${app}/Contents/MacOS/tech-pass" ]; then
      /bin/mkdir -p /usr/local/bin
      /bin/ln -sf "${app}/Contents/MacOS/tech-pass" /usr/local/bin/tech-pass
    fi
  '';
}
