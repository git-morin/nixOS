{
  autoGroups = {
    highlight-yank = { clear = true; };
    resize-splits = { clear = true; };
    close-with-q = { clear = true; };
    auto-create-dir = { clear = true; };
    last-loc = { clear = true; };
    wrap-spell = { clear = true; };
    large-file = { clear = true; };
    format-options = { clear = true; };
  };

  autoCmd = [
    # Highlight yanked text
    {
      event = ["TextYankPost"];
      desc = "Highlight when yanking (copying) text";
      group = "highlight-yank";
      callback.__raw = ''
        function()
          vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
        end
      '';
    }

    # Auto resize splits when window is resized
    {
      event = ["VimResized"];
      desc = "Auto resize splits";
      group = "resize-splits";
      callback.__raw = ''
        function()
          local current_tab = vim.fn.tabpagenr()
          vim.cmd("tabdo wincmd =")
          vim.cmd("tabnext " .. current_tab)
        end
      '';
    }

    # Close certain filetypes with q
    {
      event = ["FileType"];
      desc = "Close with q";
      group = "close-with-q";
      pattern = [
        "help"
        "lspinfo"
        "man"
        "notify"
        "qf"
        "query"
        "spectre_panel"
        "startuptime"
        "checkhealth"
        "gitsigns-blame"
      ];
      callback.__raw = ''
        function(event)
          vim.bo[event.buf].buflisted = false
          vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
        end
      '';
    }

    # Auto create directory when saving a file
    {
      event = ["BufWritePre"];
      desc = "Auto create directory";
      group = "auto-create-dir";
      callback.__raw = ''
        function(event)
          if event.match:match("^%w%w+:[\\/][\\/]") then
            return
          end
          local file = vim.uv.fs_realpath(event.match) or event.match
          vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
        end
      '';
    }

    # Go to last location when opening a buffer
    {
      event = ["BufReadPost"];
      desc = "Go to last location";
      group = "last-loc";
      callback.__raw = ''
        function(event)
          local exclude = { "gitcommit" }
          local buf = event.buf
          if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
            return
          end
          vim.b[buf].lazyvim_last_loc = true
          local mark = vim.api.nvim_buf_get_mark(buf, '"')
          local lcount = vim.api.nvim_buf_line_count(buf)
          if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
          end
        end
      '';
    }

    # Enable wrap and spell for certain filetypes
    {
      event = ["FileType"];
      desc = "Wrap and spell for text files";
      group = "wrap-spell";
      pattern = [ "gitcommit" "markdown" "text" "plaintex" ];
      callback.__raw = ''
        function()
          vim.opt_local.wrap = true
          vim.opt_local.spell = true
        end
      '';
    }

    # Disable certain features for large files
    {
      event = ["BufReadPre"];
      desc = "Disable features for large files";
      group = "large-file";
      callback.__raw = ''
        function(event)
          local file = event.match
          local size = vim.fn.getfsize(file)
          if size > 1024 * 1024 then -- 1MB
            vim.opt_local.foldmethod = "manual"
            vim.opt_local.spell = false
            vim.opt_local.swapfile = false
            vim.opt_local.undofile = false
            vim.opt_local.breakindent = false
            vim.opt_local.colorcolumn = ""
            vim.opt_local.statuscolumn = ""
            vim.opt_local.signcolumn = "no"
            vim.b.large_file = true
          end
        end
      '';
    }

    # Fix formatoptions (they get overwritten by ftplugins)
    {
      event = ["BufEnter"];
      desc = "Fix formatoptions";
      group = "format-options";
      callback.__raw = ''
        function()
          vim.opt_local.formatoptions:remove({ "c", "r", "o" })
        end
      '';
    }

    # Check if file changed outside of vim
    {
      event = ["FocusGained" "TermClose" "TermLeave"];
      desc = "Check for file changes";
      command = "checktime";
    }

    # Remove trailing whitespace on save (optional - comment out if not wanted)
    # {
    #   event = ["BufWritePre"];
    #   desc = "Remove trailing whitespace";
    #   pattern = ["*"];
    #   command = [[%s/\s\+$//e]];
    # }
  ];
}