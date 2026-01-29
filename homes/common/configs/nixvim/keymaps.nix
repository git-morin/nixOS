{
  keymaps = [
    # ==========================================================================
    # General
    # ==========================================================================
    {
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<CR>";
      options.desc = "Clear search highlight";
    }
    {
      mode = "t";
      key = "<Esc><Esc>";
      action = "<C-\\><C-n>";
      options.desc = "Exit terminal mode";
    }

    # Better up/down with wrapped lines
    {
      mode = ["n" "x"];
      key = "j";
      action = "v:count == 0 ? 'gj' : 'j'";
      options = { desc = "Down"; expr = true; silent = true; };
    }
    {
      mode = ["n" "x"];
      key = "k";
      action = "v:count == 0 ? 'gk' : 'k'";
      options = { desc = "Up"; expr = true; silent = true; };
    }

    # Move lines up/down in visual mode
    {
      mode = "v";
      key = "J";
      action = ":m '>+1<CR>gv=gv";
      options = { desc = "Move line down"; silent = true; };
    }
    {
      mode = "v";
      key = "K";
      action = ":m '<-2<CR>gv=gv";
      options = { desc = "Move line up"; silent = true; };
    }

    # Keep cursor centered when scrolling
    {
      mode = "n";
      key = "<C-d>";
      action = "<C-d>zz";
      options.desc = "Scroll down";
    }
    {
      mode = "n";
      key = "<C-u>";
      action = "<C-u>zz";
      options.desc = "Scroll up";
    }

    # Keep search results centered
    {
      mode = "n";
      key = "n";
      action = "nzzzv";
      options.desc = "Next search result";
    }
    {
      mode = "n";
      key = "N";
      action = "Nzzzv";
      options.desc = "Previous search result";
    }

    # Better paste (don't overwrite register)
    {
      mode = "x";
      key = "p";
      action = "\"_dP";
      options.desc = "Paste without yanking";
    }

    # Better indenting (stay in visual mode)
    {
      mode = "v";
      key = "<";
      action = "<gv";
      options.desc = "Indent left";
    }
    {
      mode = "v";
      key = ">";
      action = ">gv";
      options.desc = "Indent right";
    }

    # Add blank lines
    {
      mode = "n";
      key = "]<Space>";
      action = "o<Esc>k";
      options.desc = "Add blank line below";
    }
    {
      mode = "n";
      key = "[<Space>";
      action = "O<Esc>j";
      options.desc = "Add blank line above";
    }

    # Quick save
    {
      mode = ["n" "i" "x" "s"];
      key = "<C-s>";
      action = "<cmd>w<CR><Esc>";
      options.desc = "Save file";
    }

    # Quick quit
    {
      mode = "n";
      key = "<leader>qq";
      action = "<cmd>qa<CR>";
      options.desc = "Quit all";
    }

    # Select all
    {
      mode = "n";
      key = "<C-a>";
      action = "ggVG";
      options.desc = "Select all";
    }

    # Join lines without moving cursor
    {
      mode = "n";
      key = "J";
      action = "mzJ`z";
      options.desc = "Join lines";
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
    # Oil (File Explorer)
    # ==========================================================================
    {
      mode = "n";
      key = "<leader>e";
      action = "<cmd>Oil<CR>";
      options = {
        desc = "Open file explorer (Oil)";
      };
    }
    {
      mode = "n";
      key = "<leader>E";
      action = "<cmd>Oil --float<CR>";
      options = {
        desc = "Open file explorer (float)";
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