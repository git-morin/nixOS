{ pkgs, ... }:
{
  # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraplugins#extraplugins
  extraPlugins = with pkgs.vimPlugins; [
    plenary-nvim
    nui-nvim
    nvim-window-picker
    resession-nvim
  ];

  extraConfigLuaPre = ''
    -- Setup window-picker before neo-tree loads
    require('window-picker').setup({
      hint = 'floating-big-letter',
      selection_chars = 'FJDKSLA;CMRUEIWOQP',
      picker_config = {
        statusline_winbar_picker = {
          use_winbar = 'always',
        },
      },
      filter_rules = {
        include_current_win = false,
        autoselect_one = true,
        bo = {
          filetype = { 'neo-tree', 'neo-tree-popup', 'notify' },
          buftype = { 'terminal', 'quickfix' },
        },
      },
    })
  '';

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
