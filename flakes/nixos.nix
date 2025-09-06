{ inputs, lib, ... }:
let
  innerLib = import ../lib { inherit inputs; };

  allHosts = builtins.readDir ../hosts;
  filterHost = name:
    let
      hostType = allHosts.${name};
    in
      hostType == "directory" && name != "common";

  hostConfigs = builtins.mapAttrs
    (name: type:
      let
        inputsPath = ../hosts + "/${name}/inputs.nix";
      in
        if builtins.pathExists inputsPath
        then import inputsPath
        else throw "inputs.nix not found for host: ${name}"
    ) builtins.listToAttrs
          (map (name: {
            inherit name;
            value = allHosts.${name};
          }) builtins.filter filterHost builtins.attrNames allHosts);

  nixosConfigurations = builtins.mapAttrs innerLib.buildNixosConfiguration hostConfigs;

  isoConfigurations = builtins.listToAttrs
      (map (name: {
        name = "${name}-iso";
        value = innerLib.buildIsoConfiguration name hostConfigs.${name};
      }) (builtins.filter
          (name: (hostConfigs.${name}).buildIso or false)
          (builtins.attrNames hostConfigs)));

in {
  # flake-parts
  flake.nixosConfigurations = nixosConfigurations // isoConfigurations;
  # used for eval during CI
  nixosConfigurations = nixosConfigurations // isoConfigurations;
}