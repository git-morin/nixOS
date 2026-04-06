{ pkgs, ... }: {
  home.packages = with pkgs; [
    temurin-bin-21
  ];
}