{
  programs.git = {
    enable = true;
    userName = "git-morin";
    userEmail = "dev.gab.morin@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
      push.default = "simple";
      core.editor = "nvim";
    };
  };
}
