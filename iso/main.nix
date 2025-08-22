{ inputs, lib, ... }:

{
  imports = [
    ./base.nix
    ../hosts/common/iso.nix
  ];

  services.xserver.enable = lib.mkForce false;
  services.displayManager.sddm.enable = lib.mkForce false;
  services.desktopManager.plasma6.enable = lib.mkForce false;
  users.mutableUsers = lib.mkForce true;
  networking.hostName = "nixos-main-installer";
  isoImage = {
    isoName = "nixos-main-installer.iso";
    volumeID = "NIXOS_MAIN";
    isoBaseName = "nixos-main";
    makeEfiBootable = true;
    makeUsbBootable = true;
    squashfsCompression = "xz -Xdict-size 100%";
  };
}