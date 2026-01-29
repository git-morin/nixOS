{
  plugins = {
    # https://nix-community.github.io/nixvim/plugins/conform-nvim/index.html
    # stevearc/conform.nvim — Lightweight formatter plugin
    conform-nvim = {
      enable = true;
      settings = {
        format_on_save = {
          timeout_ms = 500;
          lsp_fallback = true;
        };
        formatters_by_ft = {
          lua = ["stylua"];
          javascript = ["prettierd" "prettier"];
          typescript = ["prettierd" "prettier"];
          javascriptreact = ["prettierd" "prettier"];
          typescriptreact = ["prettierd" "prettier"];
          json = ["prettierd" "prettier"];
          yaml = ["prettierd" "prettier"];
          markdown = ["prettierd" "prettier"];
          html = ["prettierd" "prettier"];
          css = ["prettierd" "prettier"];
          nix = ["nixfmt"];
          rust = ["rustfmt"];
          python = ["black"];
        };
      };
    };
  };

  keymaps = [
    {
      mode = ["n" "v"];
      key = "<leader>cf";
      action.__raw = ''
        function()
          require('conform').format({
            lsp_fallback = true,
            async = false,
            timeout_ms = 1000,
          })
        end
      '';
      options.desc = "Format buffer";
    }
  ];
}
