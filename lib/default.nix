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

    # Parses the current directory for .nix files (except default.nix)
    # and returns a list of actual package derivations
    importHomeManagerPackages =
      path: # path for scanning
      pkgs: # pkgs inputs
        let
          nixFiles = builtins.filter
            (n: builtins.match ".*\\.nix$" n != null && n != "default.nix")
            (builtins.attrNames (builtins.readDir path));

          packageNames = map (n: builtins.replaceStrings [".nix"] [""] n) nixFiles;

          getPackage = pkg:
            if pkgs ? ${pkg}
            then pkgs.${pkg}
            else null;
        in
          builtins.filter (p: p != null) (map getPackage packageNames);

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
  };
in
(mkLib null) // {
  withInputs = mkLib;
}