{
  plugins = {
    # https://nix-community.github.io/nixvim/plugins/diffview/index.html
    # sindrets/diffview.nvim — Git diff viewer
    diffview = {
      enable = true;
      settings = {
        enhanced_diff_hl = true;
        view = {
          default = {
            layout = "diff2_horizontal";
          };
          merge_tool = {
            layout = "diff3_horizontal";
          };
        };
        file_panel = {
          win_config = {
            position = "left";
            width = 35;
          };
        };
      };
    };

    # https://nix-community.github.io/nixvim/plugins/lazygit/index.html
    # kdheepak/lazygit.nvim — Lazygit integration
    lazygit = {
      enable = true;
    };
  };

  keymaps = [
    # Diffview
    {
      mode = "n";
      key = "<leader>gd";
      action = "<cmd>DiffviewOpen<CR>";
      options.desc = "Open Diffview";
    }
    {
      mode = "n";
      key = "<leader>gD";
      action = "<cmd>DiffviewClose<CR>";
      options.desc = "Close Diffview";
    }
    {
      mode = "n";
      key = "<leader>gh";
      action = "<cmd>DiffviewFileHistory %<CR>";
      options.desc = "File history";
    }
    {
      mode = "n";
      key = "<leader>gH";
      action = "<cmd>DiffviewFileHistory<CR>";
      options.desc = "Branch history";
    }

    # Lazygit
    {
      mode = "n";
      key = "<leader>gg";
      action = "<cmd>LazyGit<CR>";
      options.desc = "LazyGit";
    }
  ];
}
