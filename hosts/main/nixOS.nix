{ lib, ...}:
{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "nvidia-x11"  # nvidia is not open-source
    "nvidia-settings"  # nvidia is not open-source
    "steam"  # steam is not open-source
    "steam-original"  # steam is not open-source
    "steam-unwrapped"  # steam is not open-source
    "steam-run"  # steam is not open-source
  ];
}