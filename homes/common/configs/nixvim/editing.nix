{
  plugins = {
    # https://nix-community.github.io/nixvim/plugins/nvim-surround/index.html
    # kylechui/nvim-surround — Surround selections with delimiter pairs
    nvim-surround = {
      enable = true;
      settings = {
        keymaps = {
          insert = "<C-g>s";
          insert_line = "<C-g>S";
          normal = "ys";
          normal_cur = "yss";
          normal_line = "yS";
          normal_cur_line = "ySS";
          visual = "S";
          visual_line = "gS";
          delete = "ds";
          change = "cs";
          change_line = "cS";
        };
      };
    };

    # https://nix-community.github.io/nixvim/plugins/comment/index.html
    # numToStr/Comment.nvim — Smart commenting
    comment = {
      enable = true;
      settings = {
        padding = true;
        sticky = true;
        toggler = {
          line = "gcc";
          block = "gbc";
        };
        opleader = {
          line = "gc";
          block = "gb";
        };
        extra = {
          above = "gcO";
          below = "gco";
          eol = "gcA";
        };
      };
    };

    # https://nix-community.github.io/nixvim/plugins/flash/index.html
    # folke/flash.nvim — Fast navigation with search labels
    flash = {
      enable = true;
      settings = {
        labels = "asdfghjklqwertyuiopzxcvbnm";
        search = {
          mode = "fuzzy";
        };
        label = {
          uppercase = false;
          rainbow = {
            enabled = true;
            shade = 5;
          };
        };
        modes = {
          char = {
            jump_labels = true;
          };
          search = {
            enabled = true;
          };
        };
      };
    };
  };

  keymaps = [
    # Flash
    {
      mode = ["n" "x" "o"];
      key = "s";
      action.__raw = "function() require('flash').jump() end";
      options.desc = "Flash";
    }
    {
      mode = ["n" "x" "o"];
      key = "S";
      action.__raw = "function() require('flash').treesitter() end";
      options.desc = "Flash Treesitter";
    }
    {
      mode = "o";
      key = "r";
      action.__raw = "function() require('flash').remote() end";
      options.desc = "Remote Flash";
    }
    {
      mode = ["o" "x"];
      key = "R";
      action.__raw = "function() require('flash').treesitter_search() end";
      options.desc = "Treesitter Search";
    }
  ];
}
