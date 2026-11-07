{ lib, ...}:
{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "nvidia-x11"
    "nvidia-kernel-modules"
    "nvidia-settings"
    "spotify"
  ];
}