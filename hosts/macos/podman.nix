{ primaryUser, lib, ... }:
{
  # podman-mac-helper installs a LaunchDaemon that exposes the podman socket
  # at /var/run/docker.sock, giving full Docker CLI / SDK compatibility.
  # Runs after homebrew activation so the podman binary is available.
  system.activationScripts.postActivation.text = lib.mkOrder 1700 ''
    PODMAN_HELPER=""
    for candidate in /opt/homebrew/bin/podman-mac-helper /usr/local/bin/podman-mac-helper; do
      if [ -x "$candidate" ]; then
        PODMAN_HELPER="$candidate"
        break
      fi
    done

    if [ -n "$PODMAN_HELPER" ]; then
      HELPER_PLIST="/Library/LaunchDaemons/com.github.containers.podman.helper-${primaryUser}.plist"
      if [ ! -f "$HELPER_PLIST" ]; then
        "$PODMAN_HELPER" install -user ${primaryUser} \
          || echo "WARNING: podman-mac-helper install failed"
      fi
    else
      echo "INFO: podman-mac-helper not found yet (brew install pending). Re-run activation after first brew bundle."
    fi
  '';
}
