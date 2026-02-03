{ pkgs, ... }: {
  users = {
    mutableUsers = false;
    users = {
      root = {
        isSystemUser = true;
        hashedPassword = "$y$j9T$uQO.3JJptVjEXJPIpXIve0$sHy36.8QViyyHl8eeJC6pcaOWghC6AQ7aMKe8/nRmEB";
      };
      gab = {
        isNormalUser = true;
        description = "gab";
        uid = 1000;
        group = "gab";
        shell = pkgs.nushell;
        extraGroups = [
          "wheel"
          "networkmanager"
          "nixconfig"
        ];
        hashedPassword = "$y$j9T$nOeSRX0gqLApcicsYKr1.1$IDtjO2PT/iVRMvUmT4LtnmYHPFf9ZkHUEr60OIDuNd0";
      };
    };
    groups = {
      gab.gid = 1000;
    };
  };
}
