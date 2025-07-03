{ lib, ... }:
{
  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      download-buffer-size = 134217728;  # 128 MB
      min-free = 128000000; # 128 MB
      max-free = 1000000000; # 1 GB
      keep-outputs = true;
      keep-derivations = true;
      auto-optimise-store = true;
      max-jobs = "auto";
      use-xdg-base-directories = true;
      http-connections = 128;
      max-substitution-jobs = 128;
      log-lines = 25;
      warn-dirty = false;
      builders-use-substitutes = true;
      fallback = true;
      substituters = [
        "https://cache.nixos.org/"
        "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 2d";
    };
  };
}
