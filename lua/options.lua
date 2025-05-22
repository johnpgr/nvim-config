vim.g.mapleader = vim.keycode('<space>')
vim.g.maplocalleader = vim.keycode('<space>')
vim.opt.diffopt:append("linematch:60")
-- vim.o.clipboard = "unnamedplus"
vim.o.completeopt = "menu,menuone,popup,noinsert,noselect,preview"
vim.o.confirm = true
vim.o.cursorline = true
vim.o.expandtab = true
vim.o.wrap = false
vim.o.inccommand = "split"
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.list = false
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.mouse = "nv"
vim.o.pumheight = 15
vim.o.number = true
vim.o.numberwidth = 2
vim.o.relativenumber = false
vim.o.shiftround = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.showmode = false
vim.o.signcolumn = "yes"
vim.o.smartcase = true
vim.o.breakindent = true
vim.o.smartindent = true
vim.o.autoindent = true
vim.o.termguicolors = false
vim.o.undofile = true
vim.o.undolevels = 10000
vim.o.updatetime = 250
vim.o.timeoutlen = 500
vim.g.editorconfig = true
vim.opt.swapfile = false
vim.g.markdown_recommended_style = 0
vim.opt.showcmd = true
vim.o.cmdheight = 1
vim.opt.scrolloff = 5
vim.o.spell = false
vim.o.spelllang = "en_us"
vim.o.backspace = "indent,eol,start"
vim.g.copilot_enabled = true
vim.g.chat_autosave = true
vim.g.indent_guides = false
vim.g.zig_fmt_autosave = 0

-- UFO folding
-- vim.o.foldcolumn = "1" -- '0' is not bad
-- vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
-- vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- vim.o.foldlevelstart = 99
-- vim.o.foldenable = true
-- vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

local is_neovide = vim.g.neovide ~= nil

if is_neovide then
	vim.cmd("cd ~")
	vim.o.guifont = "FiraMono Nerd Font:h14"
	vim.g.neovide_opacity = 1.0
	vim.g.neovide_normal_opacity = 1.0
	vim.g.neovide_text_gamma = 1.0
	vim.g.neovide_text_contrast = 0.1
	vim.g.neovide_cursor_animation_length = 0
	vim.g.neovide_scroll_animation_length = 0.15

	vim.keymap.set("n", "<C-=>", function()
		vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * 1.1
	end, { desc = "Increase Neovide scale factor" })

	vim.keymap.set("n", "<C-->", function()
		vim.g.neovide_scale_factor = vim.g.neovide_scale_factor / 1.1
	end, { desc = "Decrease Neovide scale factor" })

	if vim.g.neovide then
		vim.keymap.set("v", "<C-S-c>", '"+y') -- Copy
		vim.keymap.set("n", "<C-S-v>", '"+P') -- Paste normal mode
		vim.keymap.set("v", "<C-S-v>", '"+P') -- Paste visual mode
		vim.keymap.set("c", "<C-S-v>", "<C-R>+") -- Paste command mode
		vim.keymap.set("i", "<C-S-v>", '<ESC>l"+Pli') -- Paste insert mode
	end

	vim.api.nvim_set_keymap("", "<C-S-v>", "+p<CR>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("!", "<C-S-v>", "<C-R>+", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("t", "<C-S-v>", "<C-R>+", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("v", "<C-S-v>", "<C-R>+", { noremap = true, silent = true })
end
