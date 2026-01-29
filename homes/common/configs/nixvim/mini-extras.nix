{
  plugins = {
    mini = {
      enable = true;
      modules = {
        # Icon provider (already have this, but merging modules)
        icons = {};

        # Extended a/i text objects
        ai = {
          n_lines = 500;
          custom_textobjects = {
            # Whole buffer
            g = {
              __raw = ''
                function()
                  local from = { line = 1, col = 1 }
                  local to = {
                    line = vim.fn.line('$'),
                    col = math.max(vim.fn.getline('$'):len(), 1)
                  }
                  return { from = from, to = to }
                end
              '';
            };
          };
        };

        # Better buffer deletion
        bufremove = {};

        # Move lines and selections
        move = {
          mappings = {
            left = "<M-h>";
            right = "<M-l>";
            down = "<M-j>";
            up = "<M-k>";
            line_left = "<M-h>";
            line_right = "<M-l>";
            line_down = "<M-j>";
            line_up = "<M-k>";
          };
        };

        # Split/join arguments
        splitjoin = {
          mappings = {
            toggle = "gS";
            split = "";
            join = "";
          };
        };

        # Go forward/backward with brackets
        bracketed = {
          buffer = { suffix = "b"; options = {}; };
          comment = { suffix = "c"; options = {}; };
          conflict = { suffix = "x"; options = {}; };
          diagnostic = { suffix = "d"; options = {}; };
          file = { suffix = "f"; options = {}; };
          indent = { suffix = "i"; options = {}; };
          jump = { suffix = "j"; options = {}; };
          location = { suffix = "l"; options = {}; };
          oldfile = { suffix = "o"; options = {}; };
          quickfix = { suffix = "q"; options = {}; };
          treesitter = { suffix = "t"; options = {}; };
          undo = { suffix = "u"; options = {}; };
          window = { suffix = "w"; options = {}; };
          yank = { suffix = "y"; options = {}; };
        };

        # Highlight patterns
        hipatterns = {
          highlighters = {
            fixme = { pattern = "%f[%w]()FIXME()%f[%W]"; group = "MiniHipatternsFixme"; };
            hack = { pattern = "%f[%w]()HACK()%f[%W]"; group = "MiniHipatternsHack"; };
            todo = { pattern = "%f[%w]()TODO()%f[%W]"; group = "MiniHipatternsTodo"; };
            note = { pattern = "%f[%w]()NOTE()%f[%W]"; group = "MiniHipatternsNote"; };
            hex_color = {
              __raw = "require('mini.hipatterns').gen_highlighter.hex_color()";
            };
          };
        };

        # Surround (alternative to nvim-surround, but we'll keep nvim-surround)
        # surround = {};

        # Pairs (we use nvim-autopairs instead)
        # pairs = {};

        # Indentscope - show indent scope with animated line
        indentscope = {
          symbol = "│";
          options = {
            try_as_border = true;
          };
        };

        # Cursorword - highlight word under cursor (we have illuminate)
        # cursorword = {};
      };
    };
  };

  keymaps = [
    # mini.bufremove - better buffer close
    {
      mode = "n";
      key = "<leader>bd";
      action.__raw = "function() require('mini.bufremove').delete(0, false) end";
      options.desc = "Delete buffer";
    }
    {
      mode = "n";
      key = "<leader>bD";
      action.__raw = "function() require('mini.bufremove').delete(0, true) end";
      options.desc = "Force delete buffer";
    }
  ];
}
