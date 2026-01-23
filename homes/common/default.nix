{ inputs, system, lib, innerLib, ... }:
{
  home = {
    stateVersion = lib.mkDefault "24.05";
  };

  imports = innerLib.importConfigsFromPath ./.
    ++ [ ./packages ];
}
