{
  plugins = {
    # https://nix-community.github.io/nixvim/plugins/refactoring/index.html
    # ThePrimeagen/refactoring.nvim — Structured code refactoring
    refactoring = {
      enable = true;
    };
  };

  keymaps = [
    # Extract operations (visual mode)
    {
      mode = "x";
      key = "<leader>re";
      action.__raw = "function() require('refactoring').refactor('Extract Function') end";
      options.desc = "Extract function";
    }
    {
      mode = "x";
      key = "<leader>rf";
      action.__raw = "function() require('refactoring').refactor('Extract Function To File') end";
      options.desc = "Extract function to file";
    }
    {
      mode = "x";
      key = "<leader>rv";
      action.__raw = "function() require('refactoring').refactor('Extract Variable') end";
      options.desc = "Extract variable";
    }

    # Inline operations
    {
      mode = ["n" "x"];
      key = "<leader>ri";
      action.__raw = "function() require('refactoring').refactor('Inline Variable') end";
      options.desc = "Inline variable";
    }

    # Extract block (normal mode)
    {
      mode = "n";
      key = "<leader>rb";
      action.__raw = "function() require('refactoring').refactor('Extract Block') end";
      options.desc = "Extract block";
    }
    {
      mode = "n";
      key = "<leader>rB";
      action.__raw = "function() require('refactoring').refactor('Extract Block To File') end";
      options.desc = "Extract block to file";
    }

    # Telescope integration for refactor picker
    {
      mode = ["n" "x"];
      key = "<leader>rr";
      action.__raw = "function() require('telescope').extensions.refactoring.refactors() end";
      options.desc = "Refactoring picker";
    }

    # Debug print
    {
      mode = "n";
      key = "<leader>rp";
      action.__raw = "function() require('refactoring').debug.printf({ below = true }) end";
      options.desc = "Debug print below";
    }
    {
      mode = ["n" "x"];
      key = "<leader>rd";
      action.__raw = "function() require('refactoring').debug.print_var() end";
      options.desc = "Debug print variable";
    }
    {
      mode = "n";
      key = "<leader>rc";
      action.__raw = "function() require('refactoring').debug.cleanup({}) end";
      options.desc = "Debug cleanup";
    }
  ];

  extraConfigLuaPost = ''
    -- Load refactoring into Telescope
    pcall(function()
      require('telescope').load_extension('refactoring')
    end)
  '';
}
