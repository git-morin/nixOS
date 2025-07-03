{ inputs, system, lib, ... }: {
  home = {
    username = lib.mkForce "gab-wsl";
    homeDirectory = lib.mkForce "/home/gab-wsl";
    stateVersion = "24.11";
    packages =
      let
        pkgs = import inputs.nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
        };
        packageFiles = builtins.filter
          (n: n != "default.nix" && builtins.match ".*\\.nix$" n != null)
          (builtins.attrNames (builtins.readDir ./packages));
        importPackage = file: import (./packages + "/${file}") {
          inherit pkgs inputs;
        };
        packageSets = map importPackage packageFiles;
        extractPackages = set:
          if builtins.hasAttr "home" set && builtins.hasAttr "packages" set.home
          then set.home.packages
          else [];
      in
        builtins.concatLists (map extractPackages packageSets);
  };

  imports =
    let
      configsPath = ./configs;
      configFiles = builtins.filter
        (n: n != "default.nix" && builtins.match ".*\\.nix$" n != null)
        (builtins.attrNames (builtins.readDir configsPath));
    in
      map (x: configsPath + "/${x}") configFiles;

  programs.home-manager.enable = true;
}