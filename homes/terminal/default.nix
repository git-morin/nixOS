{ inputs, system, innerLib, ... }: {
  imports = innerLib.importConfigsFromPath ./.
    ++ [ ./packages ];
}
