let
  pureLib = {
    # Read all .nix files (except _*.nix files) and import them
    importNixFiles = path:
      let
        nixFiles = builtins.filter
          (n: n != "default.nix" && builtins.match "^_.*" n == null && builtins.match ".*\\.nix$" n != null)
          (builtins.attrNames (builtins.readDir path));
      in
        map (x: path + "/${x}") nixFiles;

    # Import config files from a configs directory (excludes _*.nix files)
    importConfigsFromPath = basePath:
      let
        configsPath = basePath + "/configs";
        configFiles = builtins.filter
          (n: n != "default.nix" && builtins.match "^_.*" n == null && builtins.match ".*\\.nix$" n != null)
          (builtins.attrNames (builtins.readDir configsPath));
      in
        map (x: configsPath + "/${x}") configFiles;
  };

  withInputs = inputs: pureLib // {
    # Discover host configurations by reading _meta.nix files from host directories
    discoverHosts = { hostsDir, filterFn }:
      let
        allEntries = builtins.readDir hostsDir;

        getMeta = name:
          let metaPath = hostsDir + "/${name}/_meta.nix";
          in if builtins.pathExists metaPath
             then (import metaPath) { inherit inputs; }
             else null;

        isValidHost = name:
          let meta = getMeta name;
          in allEntries.${name} == "directory"
             && meta != null
             && filterFn name meta;

        validNames = builtins.filter isValidHost (builtins.attrNames allEntries);
      in
        builtins.listToAttrs (map (name: {
          inherit name;
          value = getMeta name;
        }) validNames);

    # Discover unique system architectures from all host _meta.nix files
    discoverSystems = hostsDir:
      let
        allHosts = (withInputs inputs).discoverHosts {
          inherit hostsDir;
          filterFn = _: _: true;
        };
        allSystems = map (host: host.system) (builtins.attrValues allHosts);
      in
        builtins.attrNames (builtins.listToAttrs (map (s: { name = s; value = true; }) allSystems));

    # Generate NixOS configuration from hosts
    buildNixosConfiguration = hostname: hostConfig:
      inputs.nixpkgs.lib.nixosSystem {
        system = hostConfig.system or "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ../hosts/${hostname}
          inputs.home-manager.nixosModules.home-manager
          inputs.nix-topology.nixosModules.default
          (import ../flakes/_home-manager.nix {
            inherit inputs;
            system = hostConfig.system or "x86_64-linux";
            userList = hostConfig.users or [];
          })
        ] ++ (hostConfig.additionalModules or []);
      };

    # Generate darwin (macOS) configuration from hosts
    buildDarwinConfiguration = hostname: hostConfig:
      inputs.nix-darwin.lib.darwinSystem {
        system = hostConfig.system or "aarch64-darwin";
        specialArgs = { inherit inputs; };
        modules = [
          ../hosts/${hostname}
          inputs.home-manager.darwinModules.home-manager
          (import ../flakes/_home-manager.nix {
            inherit inputs;
            system = hostConfig.system or "aarch64-darwin";
            userList = hostConfig.users or [];
            primaryUser = hostConfig.primaryUser or "gab";
          })
        ] ++ (hostConfig.additionalModules or []);
      };
  };
in
pureLib // { inherit withInputs; }
