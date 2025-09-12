{ pkgs, ... }: {
  home.packages = with pkgs; [
    whoami
  ];
}
