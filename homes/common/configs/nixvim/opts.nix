{
  opts = {
    # ==========================================================================
    # Line Numbers
    # ==========================================================================
    number = true;
    relativenumber = true;

    # ==========================================================================
    # UI
    # ==========================================================================
    showmode = false;  # Don't show mode (shown in statusline)
    cursorline = true;
    signcolumn = "yes";
    termguicolors = true;
    pumheight = 10;  # Maximum number of items in popup menu
    pumblend = 10;  # Popup menu transparency
    winblend = 0;  # Floating window transparency
    cmdheight = 1;
    laststatus = 3;  # Global statusline
    showtabline = 2;  # Always show tabline
    ruler = false;  # Don't show ruler (shown in statusline)
    showcmd = false;  # Don't show command in last line

    # ==========================================================================
    # Editing
    # ==========================================================================
    breakindent = true;
    smartindent = true;
    expandtab = true;
    shiftwidth = 2;
    tabstop = 2;
    softtabstop = 2;
    shiftround = true;  # Round indent to multiple of shiftwidth

    # ==========================================================================
    # Search
    # ==========================================================================
    ignorecase = true;
    smartcase = true;
    hlsearch = true;
    incsearch = true;
    inccommand = "split";  # Preview substitutions

    # ==========================================================================
    # Splits
    # ==========================================================================
    splitright = true;
    splitbelow = true;
    splitkeep = "screen";  # Keep text on screen when splitting

    # ==========================================================================
    # Scrolling
    # ==========================================================================
    scrolloff = 8;  # Lines of context
    sidescrolloff = 8;  # Columns of context
    smoothscroll = true;

    # ==========================================================================
    # Wrapping
    # ==========================================================================
    wrap = false;
    linebreak = true;  # Wrap at word boundaries
    breakindentopt = "shift:2,min:20";

    # ==========================================================================
    # Invisible Characters
    # ==========================================================================
    list = true;
    listchars.__raw = "{ tab = '» ', trail = '·', nbsp = '␣', extends = '›', precedes = '‹' }";
    fillchars.__raw = "{ eob = ' ', fold = ' ', foldopen = '', foldsep = ' ', foldclose = '' }";

    # ==========================================================================
    # Completion
    # ==========================================================================
    completeopt = "menu,menuone,noselect";
    wildmode = "longest:full,full";
    wildoptions = "pum";

    # ==========================================================================
    # Folding
    # ==========================================================================
    foldlevel = 99;
    foldlevelstart = 99;
    foldenable = true;
    foldcolumn = "1";
    foldmethod = "expr";
    foldexpr = "v:lua.vim.treesitter.foldexpr()";
    foldtext = "";  # Use treesitter for fold text

    # ==========================================================================
    # Undo & Backup
    # ==========================================================================
    undofile = true;
    undolevels = 10000;
    backup = false;
    writebackup = false;
    swapfile = false;

    # ==========================================================================
    # Performance
    # ==========================================================================
    updatetime = 200;  # Faster completion
    timeoutlen = 300;  # Faster key sequence completion
    redrawtime = 1500;
    ttimeoutlen = 10;
    lazyredraw = false;  # Don't redraw while executing macros (set true if slow)
    synmaxcol = 240;  # Only highlight first 240 columns

    # ==========================================================================
    # Mouse & Clipboard
    # ==========================================================================
    mouse = "a";
    mousemodel = "extend";
    mousemoveevent = true;

    # ==========================================================================
    # Misc
    # ==========================================================================
    confirm = true;  # Confirm before closing unsaved buffers
    virtualedit = "block";  # Allow cursor past end of line in visual block
    formatoptions = "jcroqlnt";  # Better formatting options
    grepformat = "%f:%l:%c:%m";
    grepprg = "rg --vimgrep";
    hidden = true;  # Allow hidden buffers
    sessionoptions = "buffers,curdir,tabpages,winsize,help,globals,skiprtp,folds";
    shortmess = "filnxtToOFWIcC";  # Shorter messages
    spelllang = "en";
    spelloptions = "camel";  # Treat camelCase as separate words
    jumpoptions = "view";
  };
}
