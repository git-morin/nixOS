{ inputs, system, lib, innerLib, ... }: {
  home = {
    stateVersion = "24.11";
    packages = innerLib.importPackagesFromPath ./. inputs system;
  };

  imports = innerLib.importConfigsFromPath ./.;

  programs.home-manager.enable = true;
}