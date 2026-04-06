{ pkgs, ... }:
{
  plugins = {
    # https://nix-community.github.io/nixvim/plugins/neotest/index.html
    # nvim-neotest/neotest — Test runner framework
    neotest = {
      enable = true;
      settings = {
        icons = {
          expanded = "";
          child_prefix = "";
          child_indent = " ";
          final_child_prefix = "";
          non_collapsible = "";
          collapsed = "";
          passed = "";
          running = "";
          failed = "";
          unknown = "";
          watching = "";
          skipped = "";
        };
        status = {
          virtual_text = true;
          signs = true;
        };
        output = {
          enabled = true;
          open_on_run = "short";
        };
        quickfix = {
          enabled = true;
          open = false;
        };
        floating = {
          border = "rounded";
          max_height = 0.6;
          max_width = 0.6;
        };
      };
    };
  };

  # Neotest adapters via extraPlugins (not all have nixvim modules)
  extraPlugins = with pkgs.vimPlugins; [
    neotest-python
    neotest-vitest
    neotest-jest
    neotest-java
  ];

  # Configure adapters via Lua
  extraConfigLuaPost = ''
    require('neotest').setup({
      adapters = {
        require('neotest-python')({
          dap = { justMyCode = false },
          runner = 'pytest',
        }),
        require('neotest-vitest'),
        require('neotest-jest')({
          jestCommand = 'npm test --',
          cwd = function()
            return vim.fn.getcwd()
          end,
        }),
        require('neotest-java'),
      },
    })
  '';

  keymaps = [
    # Run tests
    {
      mode = "n";
      key = "<leader>nn";
      action.__raw = "function() require('neotest').run.run() end";
      options.desc = "Run nearest test";
    }
    {
      mode = "n";
      key = "<leader>nf";
      action.__raw = "function() require('neotest').run.run(vim.fn.expand('%')) end";
      options.desc = "Run current file";
    }
    {
      mode = "n";
      key = "<leader>nS";
      action.__raw = "function() require('neotest').run.run({ suite = true }) end";
      options.desc = "Run test suite";
    }
    {
      mode = "n";
      key = "<leader>nl";
      action.__raw = "function() require('neotest').run.run_last() end";
      options.desc = "Run last test";
    }

    # Debug test
    {
      mode = "n";
      key = "<leader>nd";
      action.__raw = "function() require('neotest').run.run({ strategy = 'dap' }) end";
      options.desc = "Debug nearest test";
    }

    # Test output & UI
    {
      mode = "n";
      key = "<leader>ns";
      action.__raw = "function() require('neotest').summary.toggle() end";
      options.desc = "Toggle test summary";
    }
    {
      mode = "n";
      key = "<leader>no";
      action.__raw = "function() require('neotest').output.open({ enter = true, auto_close = true }) end";
      options.desc = "Show test output";
    }
    {
      mode = "n";
      key = "<leader>nO";
      action.__raw = "function() require('neotest').output_panel.toggle() end";
      options.desc = "Toggle output panel";
    }

    # Stop test
    {
      mode = "n";
      key = "<leader>nq";
      action.__raw = "function() require('neotest').run.stop() end";
      options.desc = "Stop test";
    }

    # Watch mode
    {
      mode = "n";
      key = "<leader>nw";
      action.__raw = "function() require('neotest').watch.toggle(vim.fn.expand('%')) end";
      options.desc = "Toggle watch mode";
    }
  ];
}
