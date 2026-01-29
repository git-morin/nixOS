{
  plugins = {
    # https://nix-community.github.io/nixvim/plugins/bufferline/index.html
    # akinsho/bufferline.nvim — Buffer tabs at top
    bufferline = {
      enable = true;
      settings = {
        options = {
          mode = "buffers";
          numbers = "none";
          close_command = "bdelete! %d";
          right_mouse_command = "bdelete! %d";
          left_mouse_command = "buffer %d";
          indicator = {
            style = "icon";
            icon = "▎";
          };
          buffer_close_icon = "󰅖";
          modified_icon = "●";
          close_icon = "";
          left_trunc_marker = "";
          right_trunc_marker = "";
          max_name_length = 18;
          max_prefix_length = 15;
          truncate_names = true;
          tab_size = 18;
          diagnostics = "nvim_lsp";
          diagnostics_update_in_insert = false;
          diagnostics_indicator = ''
            function(count, level)
              local icon = level:match("error") and " " or " "
              return " " .. icon .. count
            end
          '';
          offsets = [
            {
              filetype = "oil";
              text = "File Explorer";
              highlight = "Directory";
              separator = true;
            }
          ];
          color_icons = true;
          show_buffer_icons = true;
          show_buffer_close_icons = true;
          show_close_icon = true;
          show_tab_indicators = true;
          show_duplicate_prefix = true;
          persist_buffer_sort = true;
          separator_style = "thin";
          enforce_regular_tabs = false;
          always_show_bufferline = true;
          hover = {
            enabled = true;
            delay = 200;
            reveal = [ "close" ];
          };
          sort_by = "insert_after_current";
        };
      };
    };
  };

  keymaps = [
    # Buffer navigation
    {
      mode = "n";
      key = "<S-h>";
      action = "<cmd>BufferLineCyclePrev<CR>";
      options.desc = "Previous buffer";
    }
    {
      mode = "n";
      key = "<S-l>";
      action = "<cmd>BufferLineCycleNext<CR>";
      options.desc = "Next buffer";
    }
    {
      mode = "n";
      key = "<leader>bp";
      action = "<cmd>BufferLineTogglePin<CR>";
      options.desc = "Pin buffer";
    }
    {
      mode = "n";
      key = "<leader>bP";
      action = "<cmd>BufferLineGroupClose ungrouped<CR>";
      options.desc = "Close unpinned buffers";
    }
    {
      mode = "n";
      key = "<leader>bo";
      action = "<cmd>BufferLineCloseOthers<CR>";
      options.desc = "Close other buffers";
    }
    {
      mode = "n";
      key = "<leader>br";
      action = "<cmd>BufferLineCloseRight<CR>";
      options.desc = "Close buffers to the right";
    }
    {
      mode = "n";
      key = "<leader>bl";
      action = "<cmd>BufferLineCloseLeft<CR>";
      options.desc = "Close buffers to the left";
    }
    {
      mode = "n";
      key = "<leader>b1";
      action = "<cmd>BufferLineGoToBuffer 1<CR>";
      options.desc = "Go to buffer 1";
    }
    {
      mode = "n";
      key = "<leader>b2";
      action = "<cmd>BufferLineGoToBuffer 2<CR>";
      options.desc = "Go to buffer 2";
    }
    {
      mode = "n";
      key = "<leader>b3";
      action = "<cmd>BufferLineGoToBuffer 3<CR>";
      options.desc = "Go to buffer 3";
    }
    {
      mode = "n";
      key = "<leader>b4";
      action = "<cmd>BufferLineGoToBuffer 4<CR>";
      options.desc = "Go to buffer 4";
    }
    {
      mode = "n";
      key = "<leader>b5";
      action = "<cmd>BufferLineGoToBuffer 5<CR>";
      options.desc = "Go to buffer 5";
    }
    # Close buffer without closing window
    {
      mode = "n";
      key = "<leader>bd";
      action = "<cmd>bdelete<CR>";
      options.desc = "Delete buffer";
    }
    {
      mode = "n";
      key = "<leader>bD";
      action = "<cmd>bdelete!<CR>";
      options.desc = "Force delete buffer";
    }
  ];
}
