-- Set <space> as the leader key
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
vim.o.clipboard = 'unnamedplus'

-- Set indentation to 4 spaces
vim.o.tabstop = 4
vim.o.shiftwidth = 4

-- Line numbers
-- vim.opt.relativenumber = true
-- vim.wo.number = true
-- vim.wo.numberwidth = 2

-- Cursor line highlighting
vim.opt.cursorline = true

-- Line wrapping
vim.opt.wrap = false

-- disable cmd logging
vim.opt.showcmd = false

-- Set cursor to block on insert mode
vim.opt.guicursor = 'n-v-c-i:block'

-- Disable search results highlighting
vim.o.hlsearch = true

-- Enable break indent
vim.o.breakindent = true

-- Enable smart indent
vim.o.smartindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Disable mode display
vim.o.showmode = false

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Set spell checking
vim.opt.spell = true
vim.opt.spelllang = { 'en_us', 'pt_br' }

-- Set listchars
-- vim.cmd("set list")
-- vim.cmd("set listchars=tab:··,space:·,trail:·,extends:→,precedes:←,nbsp:␣")

-- Better splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Better scrolling experience
vim.opt.scrolloff = 8

-- No friendly swap files
vim.opt.swapfile = false
