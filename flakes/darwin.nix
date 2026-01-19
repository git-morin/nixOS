{ inputs, lib, ... }:
let
  innerLib = (import ../lib).withInputs inputs;

  allHosts = builtins.readDir ../hosts;

  filterHost = name:
    let
      hostType = allHosts.${name};
      metaPath = ../hosts + "/${name}/_meta.nix";
      hasMeta = builtins.pathExists metaPath;
      meta = if hasMeta then (import metaPath) { inherit inputs; } else {};
    in
      hostType == "directory"
      && name != "common"
      && hasMeta
      && (meta.type or "") == "darwin";

  validHostNames = builtins.filter filterHost (builtins.attrNames allHosts);

  validHosts = builtins.listToAttrs
    (map (name: {
      inherit name;
      value = allHosts.${name};
    }) validHostNames);

  hostConfigs = builtins.mapAttrs
    (name: type:
      let
        metaPath = ../hosts + "/${name}/_meta.nix";
      in
        (import metaPath) { inherit inputs; }
    ) validHosts;

  darwinConfigurations = builtins.listToAttrs
    (map (name:
      let
        hostConfig = hostConfigs.${name};
        configName = hostConfig.hostname or name;
      in {
        name = configName;
        value = innerLib.buildDarwinConfiguration name hostConfig;
      }
    ) (builtins.attrNames hostConfigs));

in {
  flake.darwinConfigurations = darwinConfigurations;
}
