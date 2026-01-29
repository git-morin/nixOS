{
  plugins = {
    # https://nix-community.github.io/nixvim/plugins/telescope/index.html
    # nvim-telescope/telescope.nvim — Highly extensible fuzzy finder
    telescope = {
      enable = true;
      extensions = {
        fzf-native.enable = true;
        ui-select.enable = true;
      };
      settings = {
        defaults = {
          layout_strategy = "horizontal";
          layout_config = {
            horizontal = {
              prompt_position = "top";
              preview_width = 0.55;
            };
            width = 0.87;
            height = 0.80;
          };
          sorting_strategy = "ascending";
          winblend = 0;
          mappings = {
            i = {
              "<C-j>" = {
                __raw = "require('telescope.actions').move_selection_next";
              };
              "<C-k>" = {
                __raw = "require('telescope.actions').move_selection_previous";
              };
              "<C-q>" = {
                __raw = "require('telescope.actions').send_selected_to_qflist + require('telescope.actions').open_qflist";
              };
            };
          };
        };
      };
      keymaps = {
        "<leader>ff" = {
          action = "find_files";
          options.desc = "Find files";
        };
        "<leader>fg" = {
          action = "live_grep";
          options.desc = "Live grep";
        };
        "<leader>fb" = {
          action = "buffers";
          options.desc = "Find buffers";
        };
        "<leader>fh" = {
          action = "help_tags";
          options.desc = "Help tags";
        };
        "<leader>fr" = {
          action = "oldfiles";
          options.desc = "Recent files";
        };
        "<leader>fc" = {
          action = "commands";
          options.desc = "Commands";
        };
        "<leader>fk" = {
          action = "keymaps";
          options.desc = "Keymaps";
        };
        "<leader>fd" = {
          action = "diagnostics";
          options.desc = "Diagnostics";
        };
        "<leader>fs" = {
          action = "lsp_document_symbols";
          options.desc = "Document symbols";
        };
        "<leader>fw" = {
          action = "grep_string";
          options.desc = "Find word under cursor";
        };
        "<leader>gc" = {
          action = "git_commits";
          options.desc = "Git commits";
        };
        "<leader>gb" = {
          action = "git_branches";
          options.desc = "Git branches";
        };
        "<leader>gS" = {
          action = "git_status";
          options.desc = "Git status (Telescope)";
        };
      };
    };
  };
}
