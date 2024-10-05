vim.opt.fillchars:append({ eob = " " })
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
}
vim.o.splitbelow = true
vim.o.mouse = "nv"
vim.o.pumheight = 10
vim.o.number = true
vim.o.relativenumber = false
vim.o.shiftround = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.showmode = true
vim.o.signcolumn = "yes"
vim.o.smartcase = true
vim.o.breakindent = true
vim.o.smartindent = true
vim.o.autoindent = true
vim.o.termguicolors = true
vim.o.undofile = true
vim.o.undolevels = 10000
vim.o.updatetime = 250
vim.o.timeoutlen = 500
vim.g.editorconfig = true
vim.opt.swapfile = true
vim.g.markdown_recommended_style = 0
vim.opt.showcmd = true
vim.opt.scrolloff = 5
vim.o.spell = true
vim.o.spelllang = "en_us,pt_br"

if vim.g.neovide then
  vim.o.guifont = "DankMono Nerd Font:h16"
  vim.g.neovide_scale_factor = 1.0
  vim.g.neovide_transparency = 1.0
end
