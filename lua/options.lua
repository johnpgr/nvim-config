-- Workaround for neovim 0.10.3 bugged :Inspect
vim.hl = vim.highlight

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
vim.o.list = false
vim.o.splitbelow = true
vim.o.mouse = "nv"
vim.o.pumheight = 10
vim.o.number = false
vim.o.numberwidth = 2
vim.o.relativenumber = false
vim.o.shiftround = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
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
vim.opt.showcmd = false
vim.o.cmdheight = 1
vim.opt.scrolloff = 5
vim.o.spell = false
vim.o.spelllang = "en_us,pt_br"
vim.o.backspace = "indent,eol,start"
vim.g.copilot_enabled = true
vim.g.chat_autosave = true
-- UFO folding
-- vim.o.foldcolumn = "1" -- '0' is not bad
-- vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
-- vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- vim.o.foldlevelstart = 99
-- vim.o.foldenable = true
-- vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

vim.diagnostic.config({
    virtual_text = false,
})

local is_neovide = vim.g.neovide ~= nil

if is_neovide then
    vim.cmd("cd ~")
    vim.o.guifont = "Consolas Nerd Font:h14"
    vim.g.neovide_scale_factor = 1

    vim.keymap.set("n", "<C-=>", function()
        vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * 1.1
    end, { desc = "Increase Neovide scale factor" })

    vim.keymap.set("n", "<C-->", function()
        vim.g.neovide_scale_factor = vim.g.neovide_scale_factor / 1.1
    end, { desc = "Decrease Neovide scale factor" })
end
