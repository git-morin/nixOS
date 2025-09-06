{ inputs, ... }:
let
  lib = import ../../lib;

  hostConfigs = builtins.mapAttrs
    (name: type: import ../hosts/${name}/inputs.nix)
    (builtins.filterAttrs (name: type: name != "common") (builtins.readDir ../hosts));

  nixosConfigurations = builtins.mapAttrs lib.buildNixosConfiguration hostConfigs;

  isoConfigurations =
    let
      hostsWithIsos = builtins.filterAttrs
        (name: config: config.buildIso or false)
        hostConfigs;
    in
      builtins.mapAttrs lib.buildIsoConfiguration hostsWithIsos;

in {
  nixosConfigurations = nixosConfigurations // isoConfigurations;
}