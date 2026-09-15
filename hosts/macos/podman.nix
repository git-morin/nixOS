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
        HELPER_UID=$(/usr/bin/id -u ${primaryUser})
        SUDO_USER=${primaryUser} SUDO_UID="$HELPER_UID" "$PODMAN_HELPER" install \
          || echo "WARNING: podman-mac-helper install failed"
      fi
    else
      echo "INFO: podman-mac-helper not found yet (brew install pending). Re-run activation after first brew bundle."
    fi

    # Inject the ZScaler CA bundle into the podman machine VM trust store so
    # `podman pull` from registries behind the corporate MITM proxy succeeds.
    # The VM is a rootless Fedora CoreOS, owned by ${primaryUser}, so we shell
    # out via `sudo -u ${primaryUser}`. A marker file makes this idempotent --
    # rerunning is cheap if the marker is missing (e.g. after `podman machine reset`).
    USER_HOME=$(/usr/bin/dscl . -read /Users/${primaryUser} NFSHomeDirectory | /usr/bin/awk '{print $2}')
    CA_BUNDLE="$USER_HOME/.certs/ca-bundle.pem"
    MARKER="$USER_HOME/.certs/.podman-machine-ca-installed"
    if [ -f "$CA_BUNDLE" ] && [ ! -f "$MARKER" ]; then
      if /usr/bin/sudo -u ${primaryUser} /opt/homebrew/bin/podman machine list --format '{{.Running}}' 2>/dev/null | /usr/bin/grep -q true; then
        echo "Installing ZScaler CA into podman machine VM trust store..."
        /bin/cat "$CA_BUNDLE" | /usr/bin/sudo -u ${primaryUser} /opt/homebrew/bin/podman machine ssh \
          -- "sudo tee /etc/pki/ca-trust/source/anchors/zscaler.pem > /dev/null && sudo update-ca-trust extract && sudo systemctl restart podman.socket && systemctl --user restart podman.socket" \
          && /usr/bin/sudo -u ${primaryUser} /usr/bin/touch "$MARKER" \
          && echo "ZScaler CA installed in podman VM (marker: $MARKER)" \
          || echo "WARNING: Failed to install ZScaler CA in podman VM."
      else
        echo "INFO: podman machine not running; skipping CA injection. Start it and re-run activation."
      fi
    fi
  '';

  environment.variables = {
    TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE = "/run/user/$UID/podman/podman.sock";
    TESTCONTAINERS_RYUK_PRIVILEGED = "true";
  };
}
