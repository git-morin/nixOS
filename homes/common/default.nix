{ inputs, system, lib, innerLib, ... }: {
  home = {
    homeDirectory = lib.mkDefault "/home/gab";
    username = lib.mkDefault "gab";
    packages = innerLib.importPackagesFromPath ./. inputs system;
  };

  imports = innerLib.importConfigsFromPath ./.;
}