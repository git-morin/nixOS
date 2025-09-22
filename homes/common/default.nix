{ inputs, system, lib, ... }: {
  home = {
    homeDirectory = lib.mkDefault "/home/gab";
    username = lib.mkDefault "gab";
    packages = lib.importPackagesFromPath ./. inputs system;
  };

  imports = lib.importConfigsFromPath ./.;
}