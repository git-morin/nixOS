{
  services.proxmox-ve = {
    enable = true;
    ipAddress = "192.168.2.55";
  };
  
  networking.hostName = "nixos-proxmox";
  
  system.stateVersion = "24.05";
}
