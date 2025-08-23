{ lib, ... }: {
  users = {
    mutableUsers = true;
    allowNoPasswordLogin = true;
    users = {
      root = {
        isSystemUser = true;
        hashedPassword = lib.mkForce ""; # Empty password for ISO installer
      };
    };
  };
}
