{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      # Nix tooling
      nil
      nh

      htop
    ];
    sessionVariables.NH_FLAKE = "/etc/nixos";
  };
}
