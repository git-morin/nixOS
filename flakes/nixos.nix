{ inputs, ... }:
let
  innerLib = (import ../lib).withInputs inputs;

  hostConfigs = innerLib.discoverHosts {
    hostsDir = ../hosts;
    filterFn = _name: meta: (meta.type or "") != "darwin";
  };
in {
  flake.nixosConfigurations = builtins.mapAttrs
    (name: hostConfig: innerLib.buildNixosConfiguration name hostConfig)
    hostConfigs;
}
