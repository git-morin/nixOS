{ inputs, lib, ... }:

let
  proxmoxConfig = import ../hosts/proxmox/proxmox.nix;
  proxmoxIP = proxmoxConfig.services.proxmox-ve.ipAddress or (builtins.throw "Missing required configuration: services.proxmox-ve.ipAddress");
in
{
  _module.args.proxmoxIP = "192.168.2.55";
  imports = [
    ./base.nix
    ../hosts/common/iso
  ];

  services.proxmox-ve.enable = lib.mkForce false;
  
  networking = {
    hostName = "nixos-proxmox-installer";
    networkmanager.enable = true;
    interfaces = lib.mkForce {};
  };
  
  environment.systemPackages = with inputs.nixpkgs.legacyPackages.x86_64-linux; [
    qemu-utils
    bridge-utils
    zfs
    lvm2
    ethtool
    tcpdump
    crun
    skopeo
  ];

  environment.etc."proxmox-install-script" = {
    text = ''
      #!/usr/bin/env bash
      PROXMOX_IP="${proxmoxIP}"
      
      echo "Proxmox NixOS Installation Guide"
      echo "================================"
      echo ""
      echo "This installer will set up NixOS with Proxmox VE services."
      echo ""
      echo "Steps:"
      echo "1. Partition disks (consider ZFS for Proxmox storage)"
      echo "2. Format partitions:"
      echo "   mkfs.ext4 /dev/sda1  # or setup ZFS pool"
      echo "3. Mount root:"
      echo "   mount /dev/sda1 /mnt"
      echo "4. Generate hardware config:"
      echo "   nixos-generate-config --root /mnt"
      echo "5. Copy this configuration:"
      echo "   cp -r /etc/nixos-config /mnt/etc/nixos/"
      echo "6. Install:"
      echo "   nixos-install --flake /mnt/etc/nixos-config#proxmox"
      echo ""
      echo "After installation, configure:"
      echo "- Network bridges for VMs"
      echo "- Storage pools"  
      echo "- Proxmox VE web interface (https://$PROXMOX_IP:8006)"
      echo ""
      echo "The Proxmox config sets IP to $PROXMOX_IP"
      echo "Adjust hosts/proxmox/proxmox.nix if this needs to be changed."
    '';
    mode = "0755";
  };
  
  # ISO image settings
  isoImage = {
    isoName = "nixos-proxmox-installer.iso";
    volumeID = "NIXOS_PROXMOX";
    isoBaseName = "nixos-proxmox";
    
    makeEfiBootable = true;
    makeUsbBootable = true;
    squashfsCompression = "xz -Xdict-size 100%";
  };
}
