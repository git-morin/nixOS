{ inputs, system, lib, innerLib, ... }: {
  home.stateVersion = "24.11";

  imports = innerLib.importConfigsFromPath ./.
    ++ [ ./packages ];

  programs.home-manager.enable = true;
}