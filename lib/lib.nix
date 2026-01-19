let
  mkLib = inputs: {
    # Read all .nix files (except default.nix and _meta.nix) and import them
    importNixFiles =
    path: # path to scan
      let
        nixFiles = builtins.filter
          (n: n != "default.nix" && n != "_meta.nix" && builtins.match ".*\\.nix$" n != null)
          (builtins.attrNames (builtins.readDir path));
      in
        map (x: path + "/${x}") nixFiles;

    # Import and process packages from a packages directory relative to the caller
    importPackagesFromPath =
      basePath: # Base path where packages directory is located
      inputs: # Flake inputs
      system: # System architecture
        let
          pkgs = import inputs.nixpkgs {
            inherit system;
            config = { allowUnfree = true; };
          };
          packagesPath = basePath + "/packages";
          packageFiles = builtins.filter
            (n: n != "default.nix" && builtins.match ".*\\.nix$" n != null)
            (builtins.attrNames (builtins.readDir packagesPath));
          importPackage = file: import (packagesPath + "/${file}") {
            inherit pkgs inputs;
          };
          packageSets = map importPackage packageFiles;
          extractPackages = set:
            if builtins.hasAttr "home" set && builtins.hasAttr "packages" set.home
            then set.home.packages
            else [];
        in
          builtins.concatLists (map extractPackages packageSets);

    # Import config files from a configs directory relative to the caller
    importConfigsFromPath =
      basePath: # Base path where configs directory is located
        let
          configsPath = basePath + "/configs";
          configFiles = builtins.filter
            (n: n != "default.nix" && builtins.match ".*\\.nix$" n != null)
            (builtins.attrNames (builtins.readDir configsPath));
        in
          map (x: configsPath + "/${x}") configFiles;

    # Generate nixOS configuration from hosts
    buildNixosConfiguration = hostname: hostConfig:
      inputs.nixpkgs.lib.nixosSystem {
        system = hostConfig.system or "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ../hosts/${hostname}
          inputs.home-manager.nixosModules.home-manager
          (import ../flakes/home-manager.nix {
            inherit inputs;
            system = hostConfig.system or "x86_64-linux";
            userList = hostConfig.users or [];
          })
        ] ++ (hostConfig.additionalModules or []);
      };

    # Generate ISO configuration from hosts
    buildIsoConfiguration = hostname: hostConfig:
      inputs.nixpkgs.lib.nixosSystem {
        system = hostConfig.system or "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ../iso/${hostname}.nix
        ];
      };

    # Generate darwin (macOS) configuration from hosts
    buildDarwinConfiguration = hostname: hostConfig:
      inputs.nix-darwin.lib.darwinSystem {
        system = hostConfig.system or "aarch64-darwin";
        specialArgs = { inherit inputs; };
        modules = [
          ../hosts/${hostname}
        ] ++ (hostConfig.additionalModules or []);
      };
  };
in
(mkLib null) // {
  withInputs = mkLib;
}