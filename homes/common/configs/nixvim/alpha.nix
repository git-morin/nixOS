{ lib, ... }:
let
  # Machine-local dashboard extension. If the file exists at runtime,
  # its returned list of alpha layout elements is appended. File lives
  # outside the flake tree, so it is never seen by git or nix eval.
  localLuaPath = "~/.config/nvim-alpha-local.lua";
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
      val = 1;
    }
    {
      # Runtime extension: if machine-local Lua file exists, append its
      # returned layout elements. Fallback to "Neovim loaded" text.
      type = "group";
      val.__raw = ''
        (function()
          local path = vim.fn.expand("${localLuaPath}")
          if vim.fn.filereadable(path) == 1 then
            local ok, result = pcall(dofile, path)
            if ok and type(result) == "table" then
              return result
            else
              return {
                { type = "text",
                  val = "alpha-local.lua error: " .. tostring(result),
                  opts = { position = "center", hl = "ErrorMsg" } },
              }
            end
          end
          return {
            { type = "text",
              val = "Neovim loaded",
              opts = { position = "center", hl = "Comment" } },
          }
        end)()
      '';
    }
  ];
  layout = defaultLayout;
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
