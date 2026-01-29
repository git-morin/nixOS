{
  plugins = {
    # https://nix-community.github.io/nixvim/plugins/trouble/index.html
    # folke/trouble.nvim — Pretty diagnostics list
    trouble = {
      enable = true;
      settings = {
        auto_close = true;
        auto_preview = true;
        focus = true;
        modes = {
          diagnostics = {
            auto_open = false;
            auto_close = true;
          };
        };
      };
    };

    # https://nix-community.github.io/nixvim/plugins/indent-blankline/index.html
    # lukas-reineke/indent-blankline.nvim — Indentation guides
    indent-blankline = {
      enable = true;
      settings = {
        indent = {
          char = "│";
          tab_char = "│";
        };
        scope = {
          enabled = true;
          show_start = true;
          show_end = false;
        };
        exclude = {
          filetypes = [
            "help"
            "alpha"
            "dashboard"
            "neo-tree"
            "Trouble"
            "trouble"
            "lazy"
            "mason"
            "notify"
            "toggleterm"
            "lazyterm"
          ];
        };
      };
    };

    # https://nix-community.github.io/nixvim/plugins/noice/index.html
    # folke/noice.nvim — UI for messages, cmdline, and popupmenu
    noice = {
      enable = true;
      settings = {
        lsp = {
          override = {
            "vim.lsp.util.convert_input_to_markdown_lines" = true;
            "vim.lsp.util.stylize_markdown" = true;
            "cmp.entry.get_documentation" = true;
          };
          signature = {
            enabled = false;  # Using lsp-signature instead
          };
        };
        presets = {
          bottom_search = true;
          command_palette = true;
          long_message_to_split = true;
          inc_rename = true;
          lsp_doc_border = true;
        };
        routes = [
          {
            filter = {
              event = "msg_show";
              kind = "";
              find = "written";
            };
            opts = {
              skip = true;
            };
          }
        ];
      };
    };

    # https://nix-community.github.io/nixvim/plugins/illuminate/index.html
    # RRethy/vim-illuminate — Highlight word under cursor
    illuminate = {
      enable = true;
      settings = {
        under_cursor = true;
        filetypes_denylist = [
          "dirbuf"
          "dirvish"
          "fugitive"
          "neo-tree"
          "oil"
          "TelescopePrompt"
        ];
      };
    };
  };

  keymaps = [
    # Trouble
    {
      mode = "n";
      key = "<leader>xx";
      action = "<cmd>Trouble diagnostics toggle<CR>";
      options.desc = "Diagnostics (Trouble)";
    }
    {
      mode = "n";
      key = "<leader>xX";
      action = "<cmd>Trouble diagnostics toggle filter.buf=0<CR>";
      options.desc = "Buffer Diagnostics (Trouble)";
    }
    {
      mode = "n";
      key = "<leader>xl";
      action = "<cmd>Trouble loclist toggle<CR>";
      options.desc = "Location List (Trouble)";
    }
    {
      mode = "n";
      key = "<leader>xq";
      action = "<cmd>Trouble qflist toggle<CR>";
      options.desc = "Quickfix List (Trouble)";
    }
    {
      mode = "n";
      key = "<leader>xr";
      action = "<cmd>Trouble lsp toggle focus=false win.position=right<CR>";
      options.desc = "LSP References (Trouble)";
    }
  ];
}
