return {
	{
		"ellisonleao/gruvbox.nvim",
		config = function()
			require("gruvbox").setup({
				undercurl = true,
				underline = true,
				bold = false,
				italic = {
					strings = false,
					emphasis = false,
					comments = false,
					operators = false,
					folds = false,
				},
				strikethrough = true,
				invert_selection = true,
				invert_signs = false,
				invert_tabline = false,
				invert_intend_guides = false,
				inverse = true,
				contrast = "hard",
				overrides = {
					SignColumn = { bg = "#1d2021" },
				},
				dim_inactive = false,
				transparent_mode = true,
			})
		end,
	},
	{
		"sainnhe/gruvbox-material",
		config = function()
			vim.g.gruvbox_material_enable_italic = false
			vim.g.gruvbox_material_background = "medium"
			vim.g.gruvbox_material_better_performance = 1
			vim.g.gruvbox_material_foreground = "material"
		end,
	},
	"folke/tokyonight.nvim",
	{ "catppuccin/nvim", name = "catppuccin" },
	"felipeagc/fleet-theme-nvim",
	"sainnhe/everforest",
	"rjshkhr/shadow.nvim",
	{ "rose-pine/neovim", name = "rosepine" },
}
