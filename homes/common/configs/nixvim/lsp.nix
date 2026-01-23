{
  plugins.lsp = {
    enable = true;

    servers = {
      nixd = {
        enable = true;
        settings = {
          nixpkgs.expr = "import <nixpkgs> {}";
          formatting.command = ["nixfmt"];
        };
      };

      lua_ls = {
        enable = true;
        settings = {
          Lua = {
            runtime.version = "LuaJIT";
            workspace.checkThirdParty = false;
            telemetry.enable = false;
            diagnostics = {
              globals = ["vim"];
            };
          };
        };
      };

      ts_ls = {
        enable = true;
      };

      rust_analyzer = {
        enable = true;
        installCargo = true;
        installRustc = true;
        settings = {
          checkOnSave.command = "clippy";
          inlayHints = {
            closingBraceHints.enable = true;
            parameterHints.enable = true;
            typeHints.enable = true;
          };
        };
      };

      jdtls = {
        enable = true;
      };
    };

    keymaps = {
      silent = true;
      lspBuf = {
        "gd" = "definition";
        "gD" = "declaration";
        "gr" = "references";
        "gi" = "implementation";
        "K" = "hover";
        "<leader>rn" = "rename";
        "<leader>ca" = "code_action";
        "<leader>f" = "format";
      };
      diagnostic = {
        "<leader>e" = "open_float";
        "[d" = "goto_prev";
        "]d" = "goto_next";
      };
    };
  };

  plugins.lsp.inlayHints = true;
}
