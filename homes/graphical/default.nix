{ inputs, system, lib, ... }: {
  home = {
    stateVersion = "24.11";
    packages = lib.importPackagesFromPath ./. inputs system;
  };

  imports = lib.importConfigsFromPath ./.;

  programs.home-manager.enable = true;
}