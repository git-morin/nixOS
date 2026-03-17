{ inputs, system, innerLib, ... }: {
  imports = innerLib.importConfigsFromPath ./.
    ++ [ ./packages ]
    ++ [ ./_secrets.nix ];
}
