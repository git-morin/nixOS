{ lib, ... }: {
  users = {
    mutableUsers = lib.mkForce true;
    allowNoPasswordLogin = lib.mkForce true;
    users = {
      root = {
        isSystemUser = true;
        hashedPassword = lib.mkForce null;
        initialHashedPassword = lib.mkForce ""; # Empty password for ISO installer
      };
    };
  };
}
