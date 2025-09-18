{ inputs, ... }:
{
  wsl.enable = true;
  wsl.defaultUser = "gab";
  wsl.startMenuLaunchers = true;
  wsl.interop.register = true;
  wsl.interop.includePath = false;

  systemd.settings.Manager = ''
      DefaultTimeoutStopSec=10s
  '';

  systemd.services.systemd-udev-trigger.enable = false;
  systemd.services.systemd-udevd.enable = false;
  boot.tmp.useTmpfs = true;
  boot.kernelParams = [ "systemd.unified_cgroup_hierarchy=0" ];
}