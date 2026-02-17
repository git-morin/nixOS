# Peon-ping Zoom-aware wrapper for Claude Code hooks.
# Mutes peon sounds when unmuted in a Zoom call via the macOS Accessibility API.
# Requires the terminal app to have Accessibility permission in System Settings.
# Only deployed on macOS where peon-ping is installed via Homebrew.
{ pkgs, lib, ... }:
{
  home.file.".claude/hooks/peon-ping/peon.sh" = lib.mkIf pkgs.stdenv.isDarwin {
    executable = true;
    text = ''
      #!/bin/bash
      # Wrapper around peon-ping that mutes sounds when unmuted in a Zoom call.
      # Uses peon's built-in .paused mechanism so peon handles suppression itself.
      #
      # Detection uses the macOS Accessibility API to check Zoom's Meeting menu for the
      # "Mute Audio" item (present only when the user is unmuted in an active call).
      # Requires the terminal app to have Accessibility permission in System Settings.
      set -uo pipefail

      REAL_PEON="/opt/homebrew/opt/peon-ping/libexec/peon.sh"
      PEON_DIR="''${CLAUDE_PEON_DIR:-$(cd "$(dirname "''${BASH_SOURCE[0]}")" && pwd)}"
      PAUSED_FILE="$PEON_DIR/.paused"

      # --- CLI subcommands: pass through directly ---
      case "''${1:-}" in
        pause|resume|toggle|status|notifications|packs|mobile|relay|preview|update|help|--help|-h)
          exec "$REAL_PEON" "$@" ;;
      esac

      # If stdin is a terminal (user ran bare 'peon'), pass through
      if [ -t 0 ]; then
        exec "$REAL_PEON" "$@"
      fi

      # --- Check if the user is unmuted in an active Zoom call ---
      # Returns 0 (true) if Zoom is in a meeting AND mic is unmuted.
      # Returns 1 (false) if Zoom isn't running, not in a meeting, muted, or on any error.
      zoom_mic_is_live() {
        osascript -e '
          tell application "System Events"
            if not (exists process "zoom.us") then return false
            tell process "zoom.us"
              return exists menu item "Mute Audio" of menu "Meeting" of menu bar 1
            end tell
          end tell
        ' 2>/dev/null | grep -q "true"
      }

      # --- Main logic ---
      if zoom_mic_is_live; then
        # Temporarily pause peon for this invocation so it skips sound playback.
        # Respect manual pause: don't unpause if the user paused independently.
        _we_paused=false
        if [ ! -f "$PAUSED_FILE" ]; then
          touch "$PAUSED_FILE"
          _we_paused=true
        fi

        "$REAL_PEON" "$@"
        _rc=$?

        if [ "$_we_paused" = true ]; then
          rm -f "$PAUSED_FILE"
        fi
        exit $_rc
      else
        exec "$REAL_PEON" "$@"
      fi
    '';
  };
}
