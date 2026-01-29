{ lib, ... }:
let
  customLayoutPath = ./_alpha-tm.nix;
  hasCustomLayout = builtins.pathExists customLayoutPath;
  defaultLayout = [
    {
      type = "padding";
      val = 4;
    }
    {
      type = "text";
      val = [
        ""
        "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗"
        "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║"
        "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║"
        "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║"
        "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║"
        "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝"
        ""
      ];
      opts = {
        position = "center";
        hl = "Type";
      };
    }
    {
      type = "padding";
      val = 2;
    }
    {
      type = "group";
      val = [
        {
          type = "button";
          val = "  Find File";
          on_press.__raw = "function() require('telescope.builtin').find_files() end";
          opts = {
            shortcut = "f";
            position = "center";
            width = 50;
            cursor = 3;
            keymap = ["n" "f" ":Telescope find_files<CR>" { noremap = true; silent = true; }];
          };
        }
        {
          type = "button";
          val = "  New File";
          on_press.__raw = "function() vim.cmd('ene') end";
          opts = {
            shortcut = "n";
            position = "center";
            width = 50;
            cursor = 3;
            keymap = ["n" "n" ":ene<CR>" { noremap = true; silent = true; }];
          };
        }
        {
          type = "button";
          val = "  Recent Files";
          on_press.__raw = "function() require('telescope.builtin').oldfiles() end";
          opts = {
            shortcut = "r";
            position = "center";
            width = 50;
            cursor = 3;
            keymap = ["n" "r" ":Telescope oldfiles<CR>" { noremap = true; silent = true; }];
          };
        }
        {
          type = "button";
          val = "  Find Word";
          on_press.__raw = "function() require('telescope.builtin').live_grep() end";
          opts = {
            shortcut = "w";
            position = "center";
            width = 50;
            cursor = 3;
            keymap = ["n" "w" ":Telescope live_grep<CR>" { noremap = true; silent = true; }];
          };
        }
        {
          type = "button";
          val = "  Quit";
          on_press.__raw = "function() vim.cmd('qa') end";
          opts = {
            shortcut = "q";
            position = "center";
            width = 50;
            cursor = 3;
            keymap = ["n" "q" ":qa<CR>" { noremap = true; silent = true; }];
          };
        }
      ];
    }
    {
      type = "padding";
      val = 2;
    }
    {
      type = "text";
      val = "Neovim loaded";
      opts = {
        position = "center";
        hl = "Comment";
      };
    }
  ];
  layout = if hasCustomLayout then (import customLayoutPath {}) else defaultLayout;
in
{
  plugins.alpha = {
    enable = true;
    settings.layout = layout;
  };
  plugins.telescope = {
    enable = true;
  };
}
