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
      isDarwin = (meta.type or "") == "darwin";
    in
      hostType == "directory"
      && name != "common"
      && name != "shared"
      && hasMeta
      && !isDarwin;

  validHostNames = builtins.filter filterHost (builtins.attrNames allHosts);

  validHosts = builtins.listToAttrs
    (map (name: {
      inherit name;
      value = allHosts.${name};
    }) validHostNames);

  hostConfigs = builtins.mapAttrs
    (name: _:
      let
        metaPath = ../hosts + "/${name}/_meta.nix";
      in
        if builtins.pathExists metaPath
        then (import metaPath) { inherit inputs; }
        else throw "_meta.nix not found for host: ${name}"
    ) validHosts;

in {
  flake.nixosConfigurations = builtins.mapAttrs
    (name: hostConfig: innerLib.buildNixosConfiguration name hostConfig)
    hostConfigs;
}
