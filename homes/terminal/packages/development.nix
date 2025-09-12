{ pkgs, ... }: {
  home.packages = with pkgs; [
    direnv
    nixd
  ];
}
