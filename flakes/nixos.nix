{ inputs, ... }:
let
  nixosConfigurations = system: config:
    builtins.mapAttrs
      (hostname: userList:
        inputs.nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ../hosts/${hostname}
            inputs.home-manager.nixosModules.home-manager
            (import ./home-manager.nix { inherit inputs system userList; })
          ] ++ (if config == "wsl" then [
            inputs.nixos-wsl.nixosModules.wsl
          ] else if config == "proxmox" then [
            inputs.proxmox-nixos.nixosModules.proxmox
          ] else [
            inputs.minegrub-theme.nixosModules.default
            "${inputs.nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
          ]);
        }
      );
in {
  flake.nixosConfigurations =
    (nixosConfigurations "x86_64-linux" "default" {
      main = [ "gab" ];
    }) //
    (nixosConfigurations "x86_64-linux" "wsl" {
      wsl = [ "gab-wsl" ];
    }) //
    (nixosConfigurations "x86_64-linux" "proxmox" {
      proxmox = [ "gab-proxmox" ];
    });
}