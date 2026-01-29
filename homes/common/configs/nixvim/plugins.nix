{
  plugins = {
    # https://nix-community.github.io/nixvim/plugins/web-devicons/index.html
    web-devicons = {
      enable = true;
    };

    # mini.nvim modules are configured in mini-extras.nix

    # https://nix-community.github.io/nixvim/plugins/which-key/index.html
    # folke/which-key.nvim — Keybinding hint popup
    which-key = {
      enable = true;
      settings = {
        preset = "modern";
        delay = 200;
        icons = {
          mappings = true;
          keys = {};
        };
        spec = [
          { __unkeyed-1 = "<leader>b"; group = "Buffer"; }
          { __unkeyed-1 = "<leader>c"; group = "Code"; }
          { __unkeyed-1 = "<leader>f"; group = "Find"; }
          { __unkeyed-1 = "<leader>g"; group = "Git"; }
          { __unkeyed-1 = "<leader>r"; group = "Refactor"; }
          { __unkeyed-1 = "<leader>s"; group = "Search/Session"; }
          { __unkeyed-1 = "<leader>t"; group = "Terminal"; }
          { __unkeyed-1 = "<leader>u"; group = "UI/Undo"; }
          { __unkeyed-1 = "<leader>w"; group = "Window"; }
          { __unkeyed-1 = "<leader>x"; group = "Trouble/Diagnostics"; }
          { __unkeyed-1 = "["; group = "Previous"; }
          { __unkeyed-1 = "]"; group = "Next"; }
          { __unkeyed-1 = "g"; group = "Goto"; }
          { __unkeyed-1 = "z"; group = "Fold/Spelling"; }
        ];
      };
    };

    # neo-tree disabled in favor of oil.nvim
    # https://nix-community.github.io/nixvim/plugins/neo-tree/index.html
    # nvim-neo-tree/neo-tree.nvim — File explorer (includes nui.nvim and plenary.nvim as deps)
    neo-tree = {
      enable = false;
    };

    # https://nix-community.github.io/nixvim/plugins/snacks/index.html
    # folke/snacks.nvim — Finder/Picker & UI helpers
    snacks = {
      enable = true;
      settings = {
        bigfile.enabled = true;
        notifier.enabled = true;
        quickfile.enabled = true;
        statuscolumn.enabled = true;
        words.enabled = true;
        dashboard.enabled = false;
      };
    };

    # https://nix-community.github.io/nixvim/plugins/heirline/index.html
    # rebelot/heirline.nvim — Custom statusline & winbars
    heirline = {
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

    # ==========================================================================
    # Code Navigation & Symbols
    # ==========================================================================

    # https://nix-community.github.io/nixvim/plugins/aerial/index.html
    # stevearc/aerial.nvim — Symbols/outline view
    aerial = {
      enable = true;
      settings = {
        backends = ["treesitter" "lsp" "markdown" "man"];
        layout = {
          min_width = 30;
          default_direction = "prefer_right";
        };
        show_guides = true;
        filter_kind = false;
        highlight_on_hover = true;
        autojump = true;
        close_on_select = false;
        keymaps = {
          "?" = "actions.show_help";
          "g?" = "actions.show_help";
          "<CR>" = "actions.jump";
          "<2-LeftMouse>" = "actions.jump";
          "<C-v>" = "actions.jump_vsplit";
          "<C-s>" = "actions.jump_split";
          "p" = "actions.scroll";
          "<C-j>" = "actions.down_and_scroll";
          "<C-k>" = "actions.up_and_scroll";
          "{" = "actions.prev";
          "}" = "actions.next";
          "[[" = "actions.prev_up";
          "]]" = "actions.next_up";
          "q" = "actions.close";
          "o" = "actions.tree_toggle";
          "za" = "actions.tree_toggle";
          "O" = "actions.tree_toggle_recursive";
          "zA" = "actions.tree_toggle_recursive";
          "l" = "actions.tree_open";
          "zo" = "actions.tree_open";
          "L" = "actions.tree_open_recursive";
          "zO" = "actions.tree_open_recursive";
          "h" = "actions.tree_close";
          "zc" = "actions.tree_close";
          "H" = "actions.tree_close_recursive";
          "zC" = "actions.tree_close_recursive";
          "zr" = "actions.tree_increase_fold_level";
          "zR" = "actions.tree_open_all";
          "zm" = "actions.tree_decrease_fold_level";
          "zM" = "actions.tree_close_all";
          "zx" = "actions.tree_sync_folds";
          "zX" = "actions.tree_sync_folds";
        };
      };
    };

    # https://nix-community.github.io/nixvim/plugins/neoconf/index.html
    # folke/neoconf.nvim — Project + global config support
    neoconf = {
      enable = true;
    };

    # https://nix-community.github.io/nixvim/plugins/neodev/index.html
    # folke/neodev.nvim — Lua development LSP support
    neodev = {
      enable = true;
    };

    # https://nix-community.github.io/nixvim/plugins/todo-comments/index.html
    todo-comments = {
      settings = {
        enable = true;
        signs = true;
      };
    };

    # https://nix-community.github.io/nixvim/plugins/lsp-signature/index.html
    lsp-signature = {
      enable = true;
      settings = {
        hint_enable = true;
        hint_prefix = " ";
        floating_window = true;
        bind = true;
      };
    };

    # https://nix-community.github.io/nixvim/plugins/luasnip/index.html
    luasnip = {
      enable = true;
      settings = {
        enable_autosnippets = true;
        store_selection_keys = "<Tab>";
      };
      filetypeExtend = {
        javascript = ["javascriptreact"];
        typescript = ["typescriptreact"];
      };
    };

    friendly-snippets.enable = true;

    # https://nix-community.github.io/nixvim/plugins/nvim-autopairs/index.html
    nvim-autopairs = {
      enable = true;
      settings = {
        check_ts = true;  # Use treesitter
        disable_filetype = ["TelescopePrompt" "vim"];
      };
    };

    # Treesitter config moved to treesitter.nix

    # lewis6991/gitsigns.nvim — Git markers in buffer
    gitsigns = {
      enable = true;
      settings = {
        signs = {
          add.text = "+";
          change.text = "~";
          delete.text = "_";
          topdelete.text = "‾";
          changedelete.text = "~";
        };
      };
    };
  };
}
