{ inputs, pkgs, lib, modulesPath, ... }:

{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    "${modulesPath}/installer/cd-dvd/channel.nix"
  ];

  nix.settings = {
    experimental-features = lib.mkDefault [ "nix-command" "flakes" ];
    trusted-users = lib.mkDefault [ "root" "@wheel" ];
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = true;
    };
  };

  networking = {
    networkmanager.enable = lib.mkDefault true;
    wireless.enable = lib.mkForce false;
    firewall.allowedTCPPorts = lib.mkDefault [ 22 ];
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    nano
    curl
    wget
    rsync
    htop
    inetutils
    dnsutils
    parted
    gptfdisk
    ntfs3g
    exfat
    unzip
    zip
    p7zip
    gcc
    gnumake
  ];

  environment.etc = {
    "nixos-config".source = ../.;
    "install-script" = {
      text = ''
        #!/usr/bin/env bash
        set -euo pipefail
        
        echo "NixOS Installer Script"
        echo "======================"
        echo ""
        echo "This ISO contains the following configurations:"
        echo "- main: Desktop/workstation configuration"
        echo "- wsl: Windows Subsystem for Linux configuration"  
        echo "- proxmox: Proxmox VE server configuration"
        echo ""
        echo "To install a specific configuration:"
        echo "1. Partition your disks (use 'fdisk' or 'parted')"
        echo "2. Format your partitions (e.g., 'mkfs.ext4 /dev/sda1')"
        echo "3. Mount your root partition (e.g., 'mount /dev/sda1 /mnt')"
        echo "4. Generate hardware config: 'nixos-generate-config --root /mnt'"
        echo "5. Copy this config: 'cp -r /etc/nixos-config /mnt/etc/nixos/'"
        echo "6. Install: 'nixos-install --flake /mnt/etc/nixos-config#<HOST>'"
        echo ""
        echo "Available hosts: main, wsl, proxmox"
      '';
      mode = "0755";
    };
  };
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
  time.timeZone = lib.mkDefault "America/Toronto";
}