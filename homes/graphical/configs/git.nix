{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "git-morin";
        email = "dev.gab.morin@gmail.com";
      };
      init.defaultBranch = "main";
      pull.rebase = false;
      push.default = "simple";
      core.editor = "nvim";
    };
  };
}
