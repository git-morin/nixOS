{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/4d842995-17a4-494d-86dd-a6135058b324";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/628B-55B5";
    fsType = "vfat";
  };

  fileSystems."/windows" = {
    device = "/dev/disk/by-uuid/84A67234A67226B8";
    fsType = "ntfs";
    options = [ "rw" "uid=1000" "gid=100" "dmask=022" "fmask=133" "windows_names" "big_writes" ];
  };

  swapDevices = [ ];
}
