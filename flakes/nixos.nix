{ inputs, ... }:
let
  lib = import ../lib { inherit inputs; };

  validHosts = builtins.filterAttrs
    (name: type:
      type == "directory" && name != "common"
    ) builtins.readDir ../hosts;

  hostConfigs = builtins.mapAttrs
    (name: type:
      let
        inputsPath = ../hosts + "/${name}/inputs.nix";
      in
        if builtins.pathExists inputsPath
        then import inputsPath
        else throw "inputs.nix not found for host: ${name}"
    ) validHosts;

  nixosConfigurations = builtins.mapAttrs lib.buildNixosConfiguration hostConfigs;

  isoConfigurations =
    let
      hostsWithIsos = builtins.filterAttrs
        (name: config: config.buildIso or false)
        hostConfigs;
    in
      builtins.mapAttrs lib.buildIsoConfiguration hostsWithIsos;

in {
  # flake-parts
  flake.nixosConfigurations = nixosConfigurations // isoConfigurations;
  # used for eval during CI
  nixosConfigurations = nixosConfigurations // isoConfigurations;
}