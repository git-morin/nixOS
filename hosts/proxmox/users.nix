{
  users.users.gab-proxmox = {
    isNormalUser = true;
    description = "Gab Proxmox User";
    extraGroups = [ "wheel" "networkmanager" ];
    group = "gab-proxmox";
  };

  users.groups.gab-proxmox = {};
}
