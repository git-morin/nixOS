{ inputs, system, ... }:
{
  services.proxmox-ve = {
    enable = true;
    ipAddress = "192.168.2.55";
  };

  nixpkgs.overlays = [
    inputs.proxmox-nixos.overlays.${system}
  ];
  
  networking.hostName = "nixos-proxmox";
  
  system.stateVersion = "24.05";
}
