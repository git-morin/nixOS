{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      # Nix tooling
      nil
      nh
    ];
    sessionVariables.NH_FLAKE = "/etc/nixos";
  };
}
