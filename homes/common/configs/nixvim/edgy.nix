{
  plugins = {
    # https://nix-community.github.io/nixvim/plugins/edgy/index.html
    # folke/edgy.nvim — Consistent window layout for side panels
    edgy = {
      enable = true;
    };
  };

  # Configure edgy via Lua because nixvim types `size` as integer,
  # but edgy expects a table like { height = N } or { width = N }.
  extraConfigLuaPost = ''
    require('edgy').setup({
      animate = { enabled = true, fps = 100, cps = 120 },
      exit_when_last = false,
      close_when_all_hidden = true,
      wo = {
        winfixwidth = true,
        winfixheight = false,
        winhighlight = "",
        signcolumn = "no",
        spell = false,
      },
      bottom = {
        {
          ft = "toggleterm",
          title = "Terminal",
          size = { height = 15 },
          filter = function(buf, win)
            return vim.api.nvim_win_get_config(win).relative == ""
          end,
        },
        { ft = "trouble", title = "Diagnostics" },
        { ft = "qf", title = "Quickfix" },
        {
          ft = "help",
          title = "Help",
          size = { height = 20 },
          filter = function(buf)
            return vim.bo[buf].buftype == "help"
          end,
        },
        { ft = "neotest-output-panel", title = "Test Output" },
        { ft = "neotest-summary", title = "Test Summary" },
        { ft = "dap-repl", title = "DAP REPL" },
      },
      left = {
        { ft = "oil", title = "Files", size = { width = 35 } },
        { ft = "aerial", title = "Symbols", size = { width = 35 } },
        { ft = "dapui_scopes", title = "DAP Scopes", size = { width = 40 } },
        { ft = "dapui_breakpoints", title = "Breakpoints", size = { width = 40 } },
        { ft = "dapui_stacks", title = "DAP Stacks", size = { width = 40 } },
        { ft = "dapui_watches", title = "DAP Watches", size = { width = 40 } },
      },
      right = {
        { ft = "grug-far", title = "Find & Replace", size = { width = 60 } },
        { ft = "dapui_console", title = "DAP Console", size = { width = 60 } },
      },
    })
  '';

  keymaps = [
    {
      mode = "n";
      key = "<leader>ue";
      action.__raw = "function() require('edgy').toggle() end";
      options.desc = "Toggle edgy panels";
    }
    {
      mode = "n";
      key = "<leader>uE";
      action.__raw = "function() require('edgy').select() end";
      options.desc = "Select edgy window";
    }
  ];
}
