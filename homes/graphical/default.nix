{ inputs, system, lib, innerLib, ... }: {
  imports = innerLib.importConfigsFromPath ./.
    ++ [ ./packages ];
}
