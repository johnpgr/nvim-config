local is_neovide = vim.g.neovide ~= nil

vim.opt.fillchars:append { eob = " " }
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.diffopt:append("linematch:60")
vim.o.clipboard = "unnamedplus"
vim.o.completeopt = "menu,menuone,popup,noinsert,noselect"
vim.o.confirm = true
vim.o.cursorline = false
vim.o.expandtab = true
vim.o.wrap = false
if vim.fn.executable("rg") ~= 0 then
    vim.o.grepprg = "rg --vimgrep"
end
vim.o.inccommand = "split"
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.list = true
vim.opt.listchars = {
    trail = "·",
    extends = "»",
    precedes = "«",
}
vim.o.mouse = "nv"
vim.o.pumheight = 10
vim.o.number = true
vim.o.relativenumber = false
vim.o.shiftround = true
vim.o.shiftwidth = 4
vim.o.showmode = false
vim.o.signcolumn = "yes"
vim.o.smartcase = true
vim.o.breakindent = true
vim.o.smartindent = true
vim.o.autoindent = true
vim.o.tabstop = 4
vim.o.termguicolors = true
vim.o.undofile = true
vim.o.undolevels = 10000
vim.o.updatetime = 250
vim.o.timeoutlen = 500
vim.g.editorconfig = true
vim.opt.swapfile = false
vim.g.markdown_recommended_style = 0
vim.opt.showcmd = true
vim.opt.scrolloff = 8

-- UFO folding
vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

if is_neovide then
    vim.o.guifont = "MonacoLigaturized Nerd Font"
    vim.g.neovide_scale_factor = 1.2
end
