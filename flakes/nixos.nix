{ inputs, ... }:
let
  nixosConfigurations = system: isWsl:
    builtins.mapAttrs
      (hostname: userList:
        inputs.nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ../hosts/${hostname}
            inputs.home-manager.nixosModules.home-manager
            (import ./home-manager.nix { inherit inputs system userList; })
          ] ++ (if isWsl then [
            inputs.nixos-wsl.nixosModules.wsl
          ] else [
            inputs.minegrub-theme.nixosModules.default
            "${inputs.nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
          ]);
        }
      );
in {
  flake.nixosConfigurations =
    (nixosConfigurations "x86_64-linux" false {
      main = [ "gab" ];
    }) //
    (nixosConfigurations "x86_64-linux" true {
      wsl = [ "gab-wsl" ];
    });
}