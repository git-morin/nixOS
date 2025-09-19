{ lib, ...}:
{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "nvidia-x11"  # nvidia is not open-source
    "nvidia-settings"  # nvidia is not open-source
  ];
}