{ pkgs, ... }:
{
  # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraplugins#extraplugins
  extraPlugins = with pkgs.vimPlugins; [
    plenary-nvim
    resession-nvim
  ];

  extraConfigLuaPost = ''
    -- Setup resession.nvim for session management
    local resession = require('resession')
    resession.setup({
      autosave = {
        enabled = true,
        interval = 60,
        notify = false,
      },
      options = {
        'binary',
        'bufhidden',
        'buflisted',
        'cmdheight',
        'diff',
        'filetype',
        'modifiable',
        'previewwindow',
        'readonly',
        'scrollbind',
        'winfixheight',
        'winfixwidth',
      },
    })

    -- Resession keymaps
    vim.keymap.set('n', '<leader>ss', resession.save, { desc = 'Save session' })
    vim.keymap.set('n', '<leader>sl', resession.load, { desc = 'Load session' })
    vim.keymap.set('n', '<leader>sd', resession.delete, { desc = 'Delete session' })

    -- vim: ts=2 sts=2 sw=2 et
  '';
}
