{ inputs, ... }:
let
  innerLib = (import ../lib).withInputs inputs;

  hostConfigs = innerLib.discoverHosts {
    hostsDir = ../hosts;
    filterFn = _name: meta: (meta.type or "") == "darwin";
  };
in {
  flake.darwinConfigurations = builtins.listToAttrs (map (name:
    let hostConfig = hostConfigs.${name};
    in {
      name = hostConfig.hostname or name;
      value = innerLib.buildDarwinConfiguration name hostConfig;
    }
  ) (builtins.attrNames hostConfigs));
}
