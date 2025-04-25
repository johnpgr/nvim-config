return {
	{
		"ellisonleao/gruvbox.nvim",
		config = function()
			require("gruvbox").setup({
				terminal_colors = true,
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
				transparent_mode = false,
			})
		end,
	},
	"vinitkumar/oscura-vim",
	{
		"sainnhe/gruvbox-material",
		config = function()
			vim.g.gruvbox_material_enable_italic = false
			vim.g.gruvbox_material_background = "hard"
			vim.g.gruvbox_material_better_performance = 1
			vim.g.gruvbox_material_foreground = "material"
		end,
	},
	"folke/tokyonight.nvim",
	{
		"catppuccin/nvim",
		config = function()
			require("catppuccin").setup({
				no_italic = true,
				no_bold = true,
			})
		end,
	},
	"felipeagc/fleet-theme-nvim",
	"sainnhe/everforest",
	"rjshkhr/shadow.nvim",
	"CreaturePhil/vim-handmade-hero",
	"AlexvZyl/nordic.nvim",
	{
		"navarasu/onedark.nvim",
		config = function()
			require("onedark").setup({
				style = "warm",
				transparent = false,
				term_colors = true,
				ending_tildes = false,
				cmp_itemkind_reverse = false,
				code_style = {
					comments = "none",
					keywords = "none",
					functions = "none",
					strings = "none",
					variables = "none",
				},
				lualine = {
					transparent = false,
				},
				colors = {},
				highlights = {},
				diagnostics = {
					darker = true,
					undercurl = true,
					background = true,
				},
			})
		end,
	},
	{
		"Mofiqul/vscode.nvim",
		config = function()
			require("vscode").setup({
				italic_comments = false,
				terminal_colors = true,
			})
		end,
	},
	{
		"rose-pine/neovim",
		name = "rose-pine",
		config = function()
			require("rose-pine").setup({
				dim_inactive_windows = true,
				extend_background_behind_borders = false,
				enable = {
					terminal = true,
					migrations = true, -- Handle deprecated options automatically
				},
				styles = {
					bold = false,
					italic = false,
					transparency = true,
				},
			})
		end,
	},
}
