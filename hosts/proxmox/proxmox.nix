{
  proxmox = {
    enable = true;
    qemuGuest.enable = true;
  };
  
  networking.hostName = "nixos-proxmox";
  
  system.stateVersion = "24.05";
}
