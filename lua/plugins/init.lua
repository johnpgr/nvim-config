local utils = require("utils")

return {
	-- Remembers last cursor position when reopening files
	"farmergreg/vim-lastplace",
	-- Adds file icons to Neovim
	{ "nvim-tree/nvim-web-devicons", enabled = vim.g.nerdicons_enable },
	-- Git diff viewer
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewFileHistory" },
		opts = { use_icons = vim.g.nerdicons_enable },
	},
	-- Undotree
	{
		cmd = "UndotreeToggle",
		"mbbill/undotree",
	},
	-- Transparent background
	"xiyaowong/transparent.nvim",
	{
		-- Multiple cursors plugin
		"mg979/vim-visual-multi",
		event = "BufRead",
		config = function()
			vim.cmd([[
            let g:VM_maps = {}
            let g:VM_maps["Goto Prev"] = "\[\["
            let g:VM_maps["Goto Next"] = "\]\]"
            "Select all occurrences under cursor
            nmap <C-M-n> <Plug>(VM-Select-All)
        ]])
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			require("which-key").setup({
				icons = {
					mappings = false,
				},
			})
		end,
	},
	{
		-- Text case conversions (snake_case, camelCase, etc.)
		"johmsalas/text-case.nvim",
		event = "BufRead",
		config = function()
			require("textcase").setup({
				prefix = "tc",
				substitude_command_name = "S",
			})
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "BufRead",
		main = "ibl",
		enabled = false,
		config = function()
			require("ibl").setup({
				indent = {
					char = "│",
				},
				enabled = false,
				scope = { enabled = false },
			})
		end,
	},
	{
		-- Code commenting plugin
		"echasnovski/mini.comment",
		event = "BufRead",
		dependencies = {
			{
				-- Context-aware commenting for different languages
				"JoosepAlviste/nvim-ts-context-commentstring",
				lazy = true,
				opts = {
					enable_autocmd = false,
				},
			},
		},
		opts = {
			options = {
				custom_commentstring = function()
					return require("ts_context_commentstring.internal").calculate_commentstring()
						or vim.bo.commentstring
				end,
			},
			mappings = {
				comment_line = "gcc",
				comment_visual = "gc",
			},
		},
	},
	{
		-- Git integration showing changes in sign column
		"lewis6991/gitsigns.nvim",
		event = "BufRead",
		cmd = { "Gitsigns" },
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			attach_to_untracked = true,
			preview_config = {
				border = "solid",
			},
		},
	},
	{
		-- Enhanced quickfix window navigation
		"stevearc/quicker.nvim",
		ft = "qf",
		opts = {},
	},
	{
		-- Task runner and job management
		"stevearc/overseer.nvim",
		cmd = { "OverseerRun", "OverseerToggle", "OverseerOpen", "OverseerQuickAction" },
		opts = {
			task_list = {
				-- min_width = { 80, 0.25 },
				bindings = {
					["R"] = "<cmd>OverseerQuickAction restart<cr>",
					["D"] = "<cmd>OverseerQuickAction dispose<cr>",
					["W"] = "<cmd>OverseerQuickAction watch<cr>",
					["S"] = "<cmd>OverseerQuickAction stop<cr>",
					["<C-l>"] = false,
					["<C-h>"] = false,
					["<C-k>"] = false,
					["<C-j>"] = false,
				},
			},
		},
	},
	{
		-- Symbols outline viewer
		"hedyhli/outline.nvim",
		event = "BufRead",
		config = function()
			require("outline").setup({
				outline_window = {
					position = "right",
				},
			})
		end,
	},
	{
		"ejrichards/mise.nvim",
		enabled = utils.is_neovide and not utils.is_windows,
		opts = {},
	},
	{
		"ahmedkhalf/project.nvim",
		enabled = utils.is_neovide,
		config = function()
			require("project_nvim").setup({})
		end,
	},
	{
		"luukvbaal/statuscol.nvim",
		event = "BufRead",
		config = function()
			local builtin = require("statuscol.builtin")
			require("statuscol").setup({
				relculright = true,
				segments = {
					{ text = { "%s" }, click = "v:lua.ScSa" },
					{ text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
					{ text = { builtin.foldfunc, " " }, click = "v:lua.ScFa" },
				},
			})
		end,
	},
	{ "beyondmarc/hlsl.vim", ft = "hlsl" },
	{
		ft = "zig",
		"speed2exe/zig-comp-diag.nvim",
		config = function()
			require("zig-comp-diag").setup()
		end,
	},
}
