{ inputs, ... }:
{
  system = "x86_64-linux";
  users = [ "terminal" ];
  additionalModules = [
    inputs.proxmox-nixos.nixosModules.proxmox-ve
    ({ ... }: {
      nixpkgs.overlays = [
        inputs.proxmox-nixos.overlays.x86_64-linux
      ];
    })
  ];
  buildIso = true;
}