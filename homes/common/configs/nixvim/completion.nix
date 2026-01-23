{
  plugins = {
    cmp = {
      enable = true;
      autoEnableSources = true;

      settings = {
        sources = [
          { name = "nvim_lsp"; priority = 1000; }
          { name = "luasnip"; priority = 750; }
          { name = "path"; priority = 500; }
          { name = "buffer"; priority = 250; }
        ];

        snippet.expand = ''
          function(args)
            require('luasnip').lsp_expand(args.body)
          end
        '';

        mapping = {
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.abort()";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<Tab>" = ''
            cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif require('luasnip').expand_or_jumpable() then
                require('luasnip').expand_or_jump()
              else
                fallback()
              end
            end, { 'i', 's' })
          '';
          "<S-Tab>" = ''
            cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif require('luasnip').jumpable(-1) then
                require('luasnip').jump(-1)
              else
                fallback()
              end
            end, { 'i', 's' })
          '';
          "<C-n>" = "cmp.mapping.select_next_item()";
          "<C-p>" = "cmp.mapping.select_prev_item()";
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
        };

        window = {
          completion.border = "rounded";
          documentation.border = "rounded";
        };
      };
    };
    cmp-nvim-lsp.enable = true;
    cmp-buffer.enable = true;
    cmp-path.enable = true;
    cmp-cmdline.enable = true;
  };
}
