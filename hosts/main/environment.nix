{ pkgs, ... }:
{
environment = {
    sessionVariables.NIXOS_FLAKE_TARGET = "main";
    systemPackages = with pkgs; [
      # Boot-loader requirement
      os-prober
      # Hyprland
      hyprpaper
      hyprcursor
      hyprpicker
      waybar
      wofi
      dunst
      swww
      grim
      slurp
      wl-clipboard
      kitty
      font-awesome
      nerd-fonts.droid-sans-mono
      pavucontrol
      networkmanagerapplet
      htop
    ];
  };
}