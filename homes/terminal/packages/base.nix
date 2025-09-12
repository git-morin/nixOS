{ pkgs, ... }: {
  programs.bash.shellAliases = {
    whoami = "coreutils --coreutils-prog=whoami";
  };

  programs.zsh.shellAliases = {
    whoami = "coreutils --coreutils-prog=whoami";
  };
}
