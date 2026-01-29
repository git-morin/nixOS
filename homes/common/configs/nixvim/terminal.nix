{
  plugins = {
    # https://nix-community.github.io/nixvim/plugins/toggleterm/index.html
    # akinsho/toggleterm.nvim — Persist and toggle multiple terminals
    toggleterm = {
      enable = true;
      settings = {
        size = ''
          function(term)
            if term.direction == "horizontal" then
              return 15
            elseif term.direction == "vertical" then
              return vim.o.columns * 0.4
            end
          end
        '';
        open_mapping = "[[<C-\\>]]";
        hide_numbers = true;
        shade_filetypes = [];
        shade_terminals = true;
        shading_factor = 2;
        start_in_insert = true;
        insert_mappings = true;
        terminal_mappings = true;
        persist_size = true;
        persist_mode = true;
        direction = "float";
        close_on_exit = true;
        shell.__raw = "vim.o.shell";
        float_opts = {
          border = "curved";
          winblend = 0;
        };
        winbar = {
          enabled = false;
        };
      };
    };
  };

  keymaps = [
    # Terminal toggles
    {
      mode = "n";
      key = "<leader>tf";
      action = "<cmd>ToggleTerm direction=float<CR>";
      options.desc = "Float terminal";
    }
    {
      mode = "n";
      key = "<leader>th";
      action = "<cmd>ToggleTerm direction=horizontal<CR>";
      options.desc = "Horizontal terminal";
    }
    {
      mode = "n";
      key = "<leader>tv";
      action = "<cmd>ToggleTerm direction=vertical<CR>";
      options.desc = "Vertical terminal";
    }
    {
      mode = "n";
      key = "<leader>tt";
      action = "<cmd>ToggleTerm<CR>";
      options.desc = "Toggle terminal";
    }
    {
      mode = "n";
      key = "<leader>ta";
      action = "<cmd>ToggleTermToggleAll<CR>";
      options.desc = "Toggle all terminals";
    }
    # Numbered terminals
    {
      mode = "n";
      key = "<leader>t1";
      action = "<cmd>1ToggleTerm<CR>";
      options.desc = "Terminal 1";
    }
    {
      mode = "n";
      key = "<leader>t2";
      action = "<cmd>2ToggleTerm<CR>";
      options.desc = "Terminal 2";
    }
    {
      mode = "n";
      key = "<leader>t3";
      action = "<cmd>3ToggleTerm<CR>";
      options.desc = "Terminal 3";
    }
  ];

  # Custom terminals (lazygit, htop, etc.) via extraConfigLua
  extraConfigLuaPost = ''
    -- Custom terminal for htop
    local Terminal = require('toggleterm.terminal').Terminal
    local htop = Terminal:new({
      cmd = "htop",
      hidden = true,
      direction = "float",
    })

    vim.keymap.set("n", "<leader>tH", function() htop:toggle() end, { desc = "Htop" })
  '';
}
