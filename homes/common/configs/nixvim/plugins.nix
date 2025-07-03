{
  plugins = {
    # https://nix-community.github.io/nixvim/plugins/web-devicons/index.html
    web-devicons = {
      enable = true;
    };

    # https://nix-community.github.io/nixvim/plugins/sleuth/index.html
    sleuth = {
      enable = true;
    };

    # https://nix-community.github.io/nixvim/plugins/lualine/index.html
    lualine = {
      enable = true;
    };
    # https://nix-community.github.io/nixvim/plugins/todo-comments/index.html
    todo-comments = {
      settings = {
        enable = true;
        signs = true;
      };
    };
  };
}
