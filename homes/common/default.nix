{ inputs, system, lib, innerLib, ... }: {
  home = {
    homeDirectory = lib.mkDefault "/home/gab";
    username = lib.mkDefault "gab";
  };

  imports = innerLib.importConfigsFromPath ./.
    ++ [ ./packages ];
}