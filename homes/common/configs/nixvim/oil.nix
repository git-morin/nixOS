{
  plugins = {
    # https://nix-community.github.io/nixvim/plugins/oil/index.html
    # stevearc/oil.nvim — Edit your filesystem like a buffer
    oil = {
      enable = true;
      settings = {
        default_file_explorer = true;  # Use oil as default file explorer
        columns = [
          "icon"
          "permissions"
          "size"
          "mtime"
        ];
        buf_options = {
          buflisted = false;
          bufhidden = "hide";
        };
        win_options = {
          wrap = false;
          signcolumn = "no";
          cursorcolumn = false;
          foldcolumn = "0";
          spell = false;
          list = false;
          conceallevel = 3;
          concealcursor = "nvic";
        };
        delete_to_trash = true;
        skip_confirm_for_simple_edits = true;
        prompt_save_on_select_new_entry = true;
        cleanup_delay_ms = 2000;
        constrain_cursor = "editable";
        experimental_watch_for_changes = true;
        keymaps = {
          "g?" = "actions.show_help";
          "<CR>" = "actions.select";
          "<C-v>" = "actions.select_vsplit";
          "<C-s>" = "actions.select_split";
          "<C-t>" = "actions.select_tab";
          "<C-p>" = "actions.preview";
          "<C-c>" = "actions.close";
          "<C-l>" = "actions.refresh";
          "-" = "actions.parent";
          "_" = "actions.open_cwd";
          "`" = "actions.cd";
          "~" = "actions.tcd";
          "gs" = "actions.change_sort";
          "gx" = "actions.open_external";
          "g." = "actions.toggle_hidden";
          "g\\\\" = "actions.toggle_trash";
        };
        use_default_keymaps = true;
        view_options = {
          show_hidden = true;
          is_hidden_file = ''
            function(name, bufnr)
              return vim.startswith(name, ".")
            end
          '';
          is_always_hidden = ''
            function(name, bufnr)
              return name == ".." or name == ".git"
            end
          '';
          natural_order = true;
          sort = [
            ["type" "asc"]
            ["name" "asc"]
          ];
        };
        float = {
          padding = 2;
          max_width = 0;
          max_height = 0;
          border = "rounded";
          win_options = {
            winblend = 0;
          };
        };
        preview = {
          max_width = 0.9;
          min_width = [ 40 0.4 ];
          max_height = 0.9;
          min_height = [ 5 0.1 ];
          border = "rounded";
          win_options = {
            winblend = 0;
          };
        };
        progress = {
          max_width = 0.9;
          min_width = [ 40 0.4 ];
          border = "rounded";
          win_options = {
            winblend = 0;
          };
        };
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "-";
      action = "<cmd>Oil<CR>";
      options.desc = "Open parent directory (Oil)";
    }
    {
      mode = "n";
      key = "<leader>-";
      action = "<cmd>Oil --float<CR>";
      options.desc = "Open Oil (float)";
    }
  ];
}
