return {
	{
		"RRethy/base16-nvim",
		config = function()
			local bg = "#0F1919"
			local accent = "#102121"
			local accent2 = "#0D2525" -- highlight

			local text = "#abb2bf"
			local dark_text = "#3E4451" -- comments, line numbers

			local keyword = "#8F939A"
			local func = "#B6AB8B"
			local types = "#65838E"
			local constant = "#A06057"

			local for_tesing = "#FF0000"

			require("base16-colorscheme").setup({
				base00 = bg,
				base01 = accent,
				base02 = accent2,
				base03 = dark_text,
				base04 = dark_text,
				base05 = text,
				base06 = for_tesing,
				base07 = for_tesing,
				base08 = text,
				base09 = constant,
				base0A = types,
				base0B = constant,
				base0C = text,
				base0D = func,
				base0E = keyword,
				base0F = text,
			})
		end,
	},
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
				style = "dark",
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
}
