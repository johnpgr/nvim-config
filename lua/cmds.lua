-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = '*',
})

require('nvim-web-devicons').set_icon({
	v = {
		icon = "",
		color = "#4b6c88",
		cterm_color = "24",
		name = "Vlang"
	}
})

vim.cmd([[
	hi! DiffDelete guibg=#ff4733
]])
