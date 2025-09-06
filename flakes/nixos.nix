{ inputs, lib, ... }:
let
  innerLib = (import ../lib).withInputs inputs;

  allHosts = builtins.readDir ../hosts;

  filterHost = name:
    let
      hostType = allHosts.${name};
    in
      hostType == "directory" && name != "common";

  validHostNames = builtins.filter filterHost (builtins.attrNames allHosts);

  validHosts = builtins.listToAttrs
    (map (name: {
      inherit name;
      value = allHosts.${name};
    }) validHostNames);

  hostConfigs = builtins.mapAttrs
    (name: type:
      let
        inputsPath = ../hosts + "/${name}/inputs.nix";
      in
        if builtins.pathExists inputsPath
        then import inputsPath
        else throw "inputs.nix not found for host: ${name}"
    ) validHosts;

  nixosConfigurations = builtins.mapAttrs
    (name: hostConfig: innerLib.buildNixosConfiguration name hostConfig)
    hostConfigs;

  hostsWithIsoNames = builtins.filter
    (name: (hostConfigs.${name}).buildIso or false)
    (builtins.attrNames hostConfigs);

  isoConfigurations = builtins.listToAttrs
    (map (name: {
      name = "${name}-iso";
      value = innerLib.buildIsoConfiguration name hostConfigs.${name};
    }) hostsWithIsoNames);

in {
  flake.nixosConfigurations = nixosConfigurations // isoConfigurations;
  nixosConfigurations = nixosConfigurations // isoConfigurations;
}