{
  keymaps = [
    # ==========================================================================
    # General
    # ==========================================================================
    {
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<CR>";
    }
    {
      mode = "t";
      key = "<Esc><Esc>";
      action = "<C-\\><C-n>";
      options = {
        desc = "Exit terminal mode";
      };
    }

    # ==========================================================================
    # Window Navigation
    # ==========================================================================
    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w><C-h>";
      options = {
        desc = "Move focus to the left window";
      };
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w><C-l>";
      options = {
        desc = "Move focus to the right window";
      };
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w><C-j>";
      options = {
        desc = "Move focus to the lower window";
      };
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w><C-k>";
      options = {
        desc = "Move focus to the upper window";
      };
    }

    # ==========================================================================
    # Neo-tree (File Explorer)
    # ==========================================================================
    {
      mode = "n";
      key = "<leader>e";
      action = "<cmd>Neotree toggle<CR>";
      options = {
        desc = "Toggle file explorer";
      };
    }
    {
      mode = "n";
      key = "<leader>o";
      action = "<cmd>Neotree focus<CR>";
      options = {
        desc = "Focus file explorer";
      };
    }
    {
      mode = "n";
      key = "<leader>be";
      action = "<cmd>Neotree buffers<CR>";
      options = {
        desc = "Buffer explorer";
      };
    }
    {
      mode = "n";
      key = "<leader>ge";
      action = "<cmd>Neotree git_status<CR>";
      options = {
        desc = "Git explorer";
      };
    }

    # ==========================================================================
    # Aerial (Symbols Outline)
    # ==========================================================================
    {
      mode = "n";
      key = "<leader>a";
      action = "<cmd>AerialToggle!<CR>";
      options = {
        desc = "Toggle aerial (symbols)";
      };
    }
    {
      mode = "n";
      key = "<leader>cs";
      action = "<cmd>AerialToggle!<CR>";
      options = {
        desc = "Toggle symbols outline";
      };
    }
    {
      mode = "n";
      key = "{";
      action = "<cmd>AerialPrev<CR>";
      options = {
        desc = "Previous aerial symbol";
      };
    }
    {
      mode = "n";
      key = "}";
      action = "<cmd>AerialNext<CR>";
      options = {
        desc = "Next aerial symbol";
      };
    }
  ];
}