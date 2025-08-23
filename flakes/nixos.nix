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
            inputs.proxmox-nixos.nixosModules.proxmox-ve
            ({ ... }: {
              nixpkgs.overlays = [
                inputs.proxmox-nixos.overlays.${system}
              ];
            })
          ] else [
            inputs.minegrub-theme.nixosModules.default
            "${inputs.nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
          ]);
        }
      );

isoConfigurations = system:
  let
    hostsWithIsos = {
      main-iso = "main";
      proxmox-iso = "proxmox";
    };
  in
    builtins.mapAttrs
      (isoName: hostName:
        inputs.nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ../iso/${hostName}.nix
          ];
        }
      ) hostsWithIsos;
in {
  flake.nixosConfigurations =
    (nixosConfigurations "x86_64-linux" "default" {
      main = [ "gab-graphical" ];
    }) //
    (nixosConfigurations "x86_64-linux" "wsl" {
      wsl = [ "gab-terminal" ];
    }) //
    (nixosConfigurations "x86_64-linux" "proxmox" {
      proxmox = [ "gab-terminal" ];
    }) //
    (isoConfigurations "x86_64-linux");
}