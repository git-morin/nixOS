let
  mkLib = inputs: {
    # Read all .nix files (except default.nix and _meta.nix) and import them
    importNixFiles = path:
      let
        nixFiles = builtins.filter
          (n: n != "default.nix" && n != "_meta.nix" && builtins.match ".*\\.nix$" n != null)
          (builtins.attrNames (builtins.readDir path));
      in
        map (x: path + "/${x}") nixFiles;

    # Import config files from a configs directory
    importConfigsFromPath = basePath:
      let
        configsPath = basePath + "/configs";
        configFiles = builtins.filter
          (n: n != "default.nix" && builtins.match ".*\\.nix$" n != null)
          (builtins.attrNames (builtins.readDir configsPath));
      in
        map (x: configsPath + "/${x}") configFiles;

    # Generate NixOS configuration from hosts
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

    # Generate darwin (macOS) configuration from hosts
    # Note: home-manager integration disabled due to wayland dependency bug in home-manager's darwin modules
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