{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/78490beb-25c4-4e14-a29a-be11eb7e1463";
    fsType = "xfs";
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/D568-2C87";
    fsType = "vfat";
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/1992027a-1115-49b9-8bed-fd4422ca238d"; }
  ];
}
