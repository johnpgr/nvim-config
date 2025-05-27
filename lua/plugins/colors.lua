return {
	"RRethy/base16-nvim",
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
				transparent_mode = false,
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
	{ "rose-pine/neovim", name = "rosepine" },
	{
		"NTBBloodbath/doom-one.nvim",
		config = function()
			-- Add color to cursor
			vim.g.doom_one_cursor_coloring = true
			-- Set :terminal colors
			vim.g.doom_one_terminal_colors = true
			-- Enable italic comments
			vim.g.doom_one_italic_comments = false
			-- Enable TS support
			vim.g.doom_one_enable_treesitter = true
			-- Color whole diagnostic text or only underline
			vim.g.doom_one_diagnostics_text_color = false
			-- Enable transparent background
			vim.g.doom_one_transparent_background = false

			-- Pumblend transparency
			vim.g.doom_one_pumblend_enable = true
			vim.g.doom_one_pumblend_transparency = 20

			-- Plugins integration
			vim.g.doom_one_plugin_neorg = true
			vim.g.doom_one_plugin_barbar = false
			vim.g.doom_one_plugin_telescope = true
			vim.g.doom_one_plugin_neogit = false
			vim.g.doom_one_plugin_nvim_tree = true
			vim.g.doom_one_plugin_dashboard = true
			vim.g.doom_one_plugin_startify = true
			vim.g.doom_one_plugin_whichkey = true
			vim.g.doom_one_plugin_indent_blankline = true
			vim.g.doom_one_plugin_vim_illuminate = true
			vim.g.doom_one_plugin_lspsaga = false
		end,
	},
	{
		"armannikoyan/rusty",
		lazy = false,
		priority = 1000,
		opts = {
			transparent = false,
			italic_comments = false,
			underline_current_line = false,
		},
		config = function(_, opts)
			require("rusty").setup(opts)
		end,
	},
	{
		"Tsuzat/NeoSolarized.nvim",
		config = function()
			require("NeoSolarized").setup({
				transparent = false,
				enable_italics = false,
				styles = {
					-- Style to be applied to different syntax groups
					comments = { italic = false },
					keywords = { italic = false },
					functions = { bold = false },
					variables = {},
					string = { italic = false },
					underline = true, -- true/false; for global underline
					undercurl = true, -- true/false; for global undercurl
				},
			})
		end,
	},
}
