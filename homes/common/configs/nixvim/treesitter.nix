{
  plugins = {
    # ==========================================================================
    # Treesitter Core
    # ==========================================================================

    # https://nix-community.github.io/nixvim/plugins/treesitter/index.html
    # nvim-treesitter/nvim-treesitter — Treesitter configurations and abstraction layer
    treesitter = {
      enable = true;
      settings = {
        highlight.enable = true;
        indent.enable = true;
      };
    };

    # ==========================================================================
    # Treesitter Extensions
    # ==========================================================================

    # https://nix-community.github.io/nixvim/plugins/treesitter-textobjects/index.html
    # nvim-treesitter/nvim-treesitter-textobjects — Text objects using treesitter
    treesitter-textobjects = {
      enable = true;
      settings = {
        select = {
          enable = true;
          lookahead = true;
          keymaps = {
            "af" = "@function.outer";
            "if" = "@function.inner";
            "ac" = "@class.outer";
            "ic" = "@class.inner";
            "aa" = "@parameter.outer";
            "ia" = "@parameter.inner";
            "ab" = "@block.outer";
            "ib" = "@block.inner";
            "al" = "@loop.outer";
            "il" = "@loop.inner";
            "ai" = "@conditional.outer";
            "ii" = "@conditional.inner";
            "a/" = "@comment.outer";
            "i/" = "@comment.inner";
          };
        };
        move = {
          enable = true;
          set_jumps = true;
          goto_next_start = {
            "]m" = "@function.outer";
            "]]" = "@class.outer";
            "]a" = "@parameter.inner";
          };
          goto_next_end = {
            "]M" = "@function.outer";
            "][" = "@class.outer";
          };
          goto_previous_start = {
            "[m" = "@function.outer";
            "[[" = "@class.outer";
            "[a" = "@parameter.inner";
          };
          goto_previous_end = {
            "[M" = "@function.outer";
            "[]" = "@class.outer";
          };
        };
        swap = {
          enable = true;
          swap_next = {
            "<leader>xp" = "@parameter.inner";
          };
          swap_previous = {
            "<leader>xP" = "@parameter.inner";
          };
        };
      };
    };

    # https://nix-community.github.io/nixvim/plugins/ts-autotag/index.html
    # windwp/nvim-ts-autotag — Auto close and rename HTML/JSX tags
    ts-autotag = {
      enable = true;
    };

    # https://nix-community.github.io/nixvim/plugins/ts-context-commentstring/index.html
    # JoosepAlviste/nvim-ts-context-commentstring — Context-aware commenting
    ts-context-commentstring = {
      enable = true;
    };
  };
}
