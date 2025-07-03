{ pkgs, ... }: {
  home.packages = with pkgs; [
    nerd-fonts.droid-sans-mono
  ];

  fonts.fontconfig.enable = true;
}
