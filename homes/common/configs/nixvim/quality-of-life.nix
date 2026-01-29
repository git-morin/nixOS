{
  plugins = {
    # https://nix-community.github.io/nixvim/plugins/dressing/index.html
    # stevearc/dressing.nvim — Better vim.ui.select and vim.ui.input
    dressing = {
      enable = true;
      settings = {
        input = {
          enabled = true;
          default_prompt = "Input";
          title_pos = "left";
          insert_only = true;
          start_in_insert = true;
          border = "rounded";
          relative = "cursor";
          prefer_width = 40;
          win_options = {
            wrap = false;
            list = true;
            listchars = "precedes:…,extends:…";
            sidescrolloff = 0;
          };
        };
        select = {
          enabled = true;
          backend = [ "telescope" "builtin" ];
          trim_prompt = true;
          telescope = {
            __raw = "require('telescope.themes').get_dropdown()";
          };
          builtin = {
            border = "rounded";
            relative = "editor";
            win_options = {
              cursorline = true;
              cursorlineopt = "both";
            };
          };
        };
      };
    };

    # https://nix-community.github.io/nixvim/plugins/fidget/index.html
    # j-hui/fidget.nvim — LSP progress indicator
    fidget = {
      enable = true;
      settings = {
        progress = {
          poll_rate = 0;
          suppress_on_insert = false;
          ignore_done_already = false;
          display = {
            render_limit = 16;
            done_ttl = 3;
            done_icon = "✔";
            done_style = "Constant";
            progress_icon = {
              pattern = "dots";
              period = 1;
            };
          };
        };
        notification = {
          poll_rate = 10;
          filter = "info";
          override_vim_notify = false;
          window = {
            normal_hl = "Comment";
            winblend = 0;
            border = "none";
            align = "bottom";
          };
        };
      };
    };

    # https://nix-community.github.io/nixvim/plugins/inc-rename/index.html
    # smjonas/inc-rename.nvim — Incremental rename preview
    inc-rename = {
      enable = true;
      settings = {
        input_buffer_type = "dressing";
      };
    };

    # https://nix-community.github.io/nixvim/plugins/nvim-colorizer/index.html
    # NvChad/nvim-colorizer.lua — Highlight color codes
    nvim-colorizer = {
      enable = true;
      userDefaultOptions = {
        RGB = true;
        RRGGBB = true;
        names = false;
        RRGGBBAA = true;
        AARRGGBB = true;
        rgb_fn = true;
        hsl_fn = true;
        css = true;
        css_fn = true;
        mode = "background";
        tailwind = true;
        sass = {
          enable = true;
          parsers = [ "css" ];
        };
        virtualtext = "■";
      };
    };

    # https://nix-community.github.io/nixvim/plugins/nvim-bqf/index.html
    # kevinhwang91/nvim-bqf — Better quickfix window
    nvim-bqf = {
      enable = true;
      settings = {
        auto_enable = true;
        auto_resize_height = true;
        preview = {
          auto_preview = true;
          border = "rounded";
          show_title = true;
          show_scroll_bar = true;
          delay_syntax = 80;
          win_height = 12;
          win_vheight = 12;
          winblend = 0;
        };
        func_map = {
          open = "<CR>";
          openc = "o";
          drop = "O";
          split = "<C-s>";
          vsplit = "<C-v>";
          tab = "t";
          tabb = "T";
          tabc = "<C-t>";
          tabdrop = "";
          ptogglemode = "zp";
          ptoggleitem = "p";
          ptoggleauto = "P";
          pscrollup = "<C-b>";
          pscrolldown = "<C-f>";
          fzffilter = "zf";
          prevfile = "<C-p>";
          nextfile = "<C-n>";
          prevhist = "<";
          nexthist = ">";
          lastleave = "'\"";
          stoggleup = "<S-Tab>";
          stoggledown = "<Tab>";
          stogglevm = "<Tab>";
          stogglebuf = "'<Tab>";
          sclear = "z<Tab>";
          filter = "zn";
          filterr = "zN";
        };
      };
    };

    # https://nix-community.github.io/nixvim/plugins/undotree/index.html
    # mbbill/undotree — Undo history visualization
    undotree = {
      enable = true;
      settings = {
        AutoOpenDiff = true;
        FocusOnToggle = true;
        HighlightChangedText = true;
        HighlightChangedWithSign = true;
        HighlightSyntaxAdd = "DiffAdd";
        HighlightSyntaxChange = "DiffChange";
        HighlightSyntaxDel = "DiffDelete";
        SetFocusWhenToggle = true;
        ShortIndicators = false;
        TreeNodeShape = "*";
        TreeVertShape = "|";
        TreeSplitShape = "/";
        TreeReturnShape = "\\";
        WindowLayout = 2;
      };
    };

    # https://nix-community.github.io/nixvim/plugins/lastplace/index.html
    # ethanholz/nvim-lastplace — Remember cursor position
    lastplace = {
      enable = true;
      settings = {
        lastplace_ignore_buftype = [ "quickfix" "nofile" "help" ];
        lastplace_ignore_filetype = [ "gitcommit" "gitrebase" "svn" "hgcommit" ];
        lastplace_open_folds = true;
      };
    };

    # https://nix-community.github.io/nixvim/plugins/better-escape/index.html
    # max397574/better-escape.nvim — Escape insert mode with jk/jj
    better-escape = {
      enable = true;
      settings = {
        timeout = 200;
        mappings = {
          i = {
            j = {
              k = "<Esc>";
              j = "<Esc>";
            };
          };
          c = {
            j = {
              k = "<Esc>";
              j = "<Esc>";
            };
          };
          t = {
            j = {
              k = "<C-\\><C-n>";
            };
          };
          v = {
            j = {
              k = "<Esc>";
            };
          };
          s = {
            j = {
              k = "<Esc>";
            };
          };
        };
      };
    };

    # https://nix-community.github.io/nixvim/plugins/hlslens/index.html
    # kevinhwang91/nvim-hlslens — Better search highlighting
    hlslens = {
      enable = true;
      settings = {
        calm_down = true;
        nearest_only = false;
        nearest_float_when = "auto";
      };
    };

    # https://nix-community.github.io/nixvim/plugins/spectre/index.html
    # nvim-pack/nvim-spectre — Search and replace across files
    spectre = {
      enable = true;
      settings = {
        live_update = true;
        is_insert_mode = true;
        default = {
          find = {
            cmd = "rg";
            options = [ "--color=never" "--no-heading" "--with-filename" "--line-number" "--column" ];
          };
          replace = {
            cmd = "sed";
          };
        };
      };
    };
  };

  keymaps = [
    # Inc-rename
    {
      mode = "n";
      key = "<leader>rn";
      action.__raw = ''
        function()
          return ":IncRename " .. vim.fn.expand("<cword>")
        end
      '';
      options = {
        desc = "Incremental rename";
        expr = true;
      };
    }
    # Undotree
    {
      mode = "n";
      key = "<leader>u";
      action = "<cmd>UndotreeToggle<CR>";
      options.desc = "Toggle undotree";
    }
    # Spectre
    {
      mode = "n";
      key = "<leader>sr";
      action.__raw = "function() require('spectre').open() end";
      options.desc = "Search and replace";
    }
    {
      mode = "n";
      key = "<leader>sW";
      action.__raw = "function() require('spectre').open_visual({ select_word = true }) end";
      options.desc = "Search current word";
    }
    {
      mode = "v";
      key = "<leader>sw";
      action.__raw = "function() require('spectre').open_visual() end";
      options.desc = "Search selection";
    }
    {
      mode = "n";
      key = "<leader>sF";
      action.__raw = "function() require('spectre').open_file_search({ select_word = true }) end";
      options.desc = "Search in current file";
    }
    # Better hlslens with n/N
    {
      mode = "n";
      key = "n";
      action.__raw = "[[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]]";
      options = {
        desc = "Next search result";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "N";
      action.__raw = "[[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]]";
      options = {
        desc = "Previous search result";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "*";
      action.__raw = "[[*<Cmd>lua require('hlslens').start()<CR>]]";
      options.silent = true;
    }
    {
      mode = "n";
      key = "#";
      action.__raw = "[[#<Cmd>lua require('hlslens').start()<CR>]]";
      options.silent = true;
    }
  ];
}
