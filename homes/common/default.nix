{ inputs, system, lib, innerLib, ... }:
{
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  imports = innerLib.importConfigsFromPath ./.
    ++ [ ./packages ];
}
