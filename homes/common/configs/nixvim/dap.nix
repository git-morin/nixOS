{ pkgs, ... }:
{
  plugins = {
    # https://nix-community.github.io/nixvim/plugins/dap/index.html
    # mfussenegger/nvim-dap — Debug Adapter Protocol client
    dap = {
      enable = true;

      # Adapter configurations
      configurations = {
        # Node.js / TypeScript
        typescript = [
          {
            type = "node2";
            request = "launch";
            name = "Launch file";
            program = "\${file}";
            cwd = "\${workspaceFolder}";
            sourceMaps = true;
            protocol = "inspector";
          }
          {
            type = "node2";
            request = "attach";
            name = "Attach to process";
            processId.__raw = "require('dap.utils').pick_process";
            cwd = "\${workspaceFolder}";
            sourceMaps = true;
          }
        ];
        javascript = [
          {
            type = "node2";
            request = "launch";
            name = "Launch file";
            program = "\${file}";
            cwd = "\${workspaceFolder}";
          }
        ];
        python = [
          {
            type = "python";
            request = "launch";
            name = "Launch file";
            program = "\${file}";
            pythonPath.__raw = ''
              function()
                local cwd = vim.fn.getcwd()
                if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
                  return cwd .. '/venv/bin/python'
                elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
                  return cwd .. '/.venv/bin/python'
                else
                  return '/usr/bin/python3'
                end
              end
            '';
          }
        ];
        java = [
          {
            type = "java";
            request = "launch";
            name = "Launch Java";
            mainClass = "";
          }
        ];
        rust = [
          {
            type = "codelldb";
            request = "launch";
            name = "Launch Rust";
            program.__raw = ''
              function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
              end
            '';
            cwd = "\${workspaceFolder}";
            stopOnEntry = false;
          }
        ];
      };

      adapters = {
        servers = {
          codelldb = {
            port = 13000;
            executable = {
              command = "codelldb";
              args = [ "--port" "13000" ];
            };
          };
        };
      };
    };

    # Top-level extensions (new nixvim layout)
    # https://nix-community.github.io/nixvim/plugins/dap-ui/index.html
    dap-ui = {
      enable = true;
      settings = {
        icons = {
          expanded = "";
          collapsed = "";
          current_frame = "";
        };
        layouts = [
          {
            elements = [
              { id = "scopes"; size = 0.25; }
              { id = "breakpoints"; size = 0.25; }
              { id = "stacks"; size = 0.25; }
              { id = "watches"; size = 0.25; }
            ];
            position = "left";
            size = 40;
          }
          {
            elements = [
              { id = "repl"; size = 0.5; }
              { id = "console"; size = 0.5; }
            ];
            position = "bottom";
            size = 10;
          }
        ];
        floating = {
          border = "rounded";
          mappings = {
            close = [ "q" "<Esc>" ];
          };
        };
      };
    };

    # https://nix-community.github.io/nixvim/plugins/dap-virtual-text/index.html
    dap-virtual-text = {
      enable = true;
      settings = {
        enabled = true;
        enabled_commands = true;
        highlight_changed_variables = true;
        highlight_new_as_changed = false;
        show_stop_reason = true;
        commented = false;
        virt_text_pos = "eol";
      };
    };

    # https://nix-community.github.io/nixvim/plugins/dap-python/index.html
    dap-python = {
      enable = true;
      settings = {
        console = "integratedTerminal";
      };
    };
  };

  # DAP-related packages
  extraPlugins = with pkgs.vimPlugins; [
    nvim-dap-lldb
  ];

  keymaps = [
    # Breakpoints
    {
      mode = "n";
      key = "<leader>db";
      action.__raw = "function() require('dap').toggle_breakpoint() end";
      options.desc = "Toggle breakpoint";
    }
    {
      mode = "n";
      key = "<leader>dB";
      action.__raw = "function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end";
      options.desc = "Conditional breakpoint";
    }
    {
      mode = "n";
      key = "<leader>dl";
      action.__raw = "function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end";
      options.desc = "Log point";
    }

    # Execution
    {
      mode = "n";
      key = "<leader>dc";
      action.__raw = "function() require('dap').continue() end";
      options.desc = "Continue / Start";
    }
    {
      mode = "n";
      key = "<F5>";
      action.__raw = "function() require('dap').continue() end";
      options.desc = "Debug: Continue";
    }
    {
      mode = "n";
      key = "<leader>di";
      action.__raw = "function() require('dap').step_into() end";
      options.desc = "Step into";
    }
    {
      mode = "n";
      key = "<F11>";
      action.__raw = "function() require('dap').step_into() end";
      options.desc = "Debug: Step into";
    }
    {
      mode = "n";
      key = "<leader>do";
      action.__raw = "function() require('dap').step_over() end";
      options.desc = "Step over";
    }
    {
      mode = "n";
      key = "<F10>";
      action.__raw = "function() require('dap').step_over() end";
      options.desc = "Debug: Step over";
    }
    {
      mode = "n";
      key = "<leader>dO";
      action.__raw = "function() require('dap').step_out() end";
      options.desc = "Step out";
    }
    {
      mode = "n";
      key = "<S-F11>";
      action.__raw = "function() require('dap').step_out() end";
      options.desc = "Debug: Step out";
    }

    # UI & Info
    {
      mode = "n";
      key = "<leader>du";
      action.__raw = "function() require('dapui').toggle() end";
      options.desc = "Toggle DAP UI";
    }
    {
      mode = "n";
      key = "<leader>de";
      action.__raw = "function() require('dapui').eval() end";
      options.desc = "Eval expression";
    }
    {
      mode = "v";
      key = "<leader>de";
      action.__raw = "function() require('dapui').eval() end";
      options.desc = "Eval selection";
    }
    {
      mode = "n";
      key = "<leader>dr";
      action.__raw = "function() require('dap').repl.toggle() end";
      options.desc = "Toggle REPL";
    }
    {
      mode = "n";
      key = "<leader>dR";
      action.__raw = "function() require('dap').run_last() end";
      options.desc = "Run last";
    }

    # Terminate
    {
      mode = "n";
      key = "<leader>dt";
      action.__raw = "function() require('dap').terminate() end";
      options.desc = "Terminate";
    }
    {
      mode = "n";
      key = "<leader>dx";
      action.__raw = ''
        function()
          require('dap').terminate()
          require('dapui').close()
        end
      '';
      options.desc = "Terminate and close UI";
    }
  ];

  # Auto open/close DAP UI
  extraConfigLuaPost = ''
    local dap, dapui = require('dap'), require('dapui')
    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated['dapui_config'] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
      dapui.close()
    end

    -- Breakpoint icons
    local empty = ""
    vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DapBreakpoint', linehl = empty, numhl = empty })
    vim.fn.sign_define('DapBreakpointCondition', { text = '◐', texthl = 'DapBreakpointCondition', linehl = empty, numhl = empty })
    vim.fn.sign_define('DapLogPoint', { text = '◆', texthl = 'DapLogPoint', linehl = empty, numhl = empty })
    vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' })
    vim.fn.sign_define('DapBreakpointRejected', { text = '○', texthl = 'DapBreakpointRejected', linehl = empty, numhl = empty })
  '';
}
