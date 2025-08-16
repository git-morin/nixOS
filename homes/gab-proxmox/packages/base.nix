{ pkgs, inputs }: {
  home.packages = with pkgs; [
    htop
    curl
    wget
    git
    vim
  ];
}
