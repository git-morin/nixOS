{ pkgs, ... }:{
  system = {
    stateVersion = "25.11";
    activationScripts = {
        fixHomeOwnership = {
          text = ''
            chown -R gab:gab /home/gab || true
          '';
          deps = [];
        };
        wslCompat = {
          text = ''
            mkdir -p /usr/bin
            ln -sf ${pkgs.systemd}/bin/systemctl /usr/bin/systemctl
          '';
          deps = [];
        };
    };
  };
}
