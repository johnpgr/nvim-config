return {
	"miguelcrespo/scratch-buffer.nvim",
	-- enabled = false,
    event = "VimEnter",
	config = function()
		require("scratch-buffer").setup({
			filetype = "lua", -- fennel, python
			buffname = "*scratch*",
			with_lsp = true, -- Use a temporal file to start the LSP server
			heading = {
				" This buffer is for notes you don't want to save, and for Lua evaluation.",
				" If you want to create a file, Visit that file with <leader>ff or <leader>b",
				" then enter the text in that file's own buffer.",
			},
			with_neovim_version = true, -- Display the Neovim version bellow the heading
		})
	end,
	dependencies = {
		-- Recommended if you want interactive evaluation
        "Olical/conjure",
	},
}
