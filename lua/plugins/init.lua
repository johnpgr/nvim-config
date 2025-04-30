local utils = require("utils")

return {
	-- Remembers last cursor position when reopening files
	"farmergreg/vim-lastplace",
	-- Adds file icons to Neovim
	{ "nvim-tree/nvim-web-devicons", enabled = utils.nerd_icons },
	-- Git diff viewer
	"sindrets/diffview.nvim",
	-- Undotree
	"mbbill/undotree",
	-- Workspace diagnostics
	"artemave/workspace-diagnostics.nvim",
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
		opts = {
			preset = "helix",
			win = { border = "none" },
		},
	},
	{
		-- Text case conversions (snake_case, camelCase, etc.)
		"johmsalas/text-case.nvim",
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
		config = function()
			vim.api.nvim_set_hl(0, "IndentGuides", { fg = "#2f2d39" })
			require("ibl").setup({
				indent = {
					char = "│",
					highlight = "IndentGuides",
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
				comment_line = "<C-_>",
				comment_visual = "<C-_>",
			},
		},
	},
	{
		-- V programming language support
		"ollykel/v-vim",
		init = function()
			if utils.nerd_icons then
				require("nvim-web-devicons").set_icon({
					v = {
						icon = "",
						color = "#5d87bf",
						cterm_color = "59",
						name = "Vlang",
					},
					vsh = {
						icon = "",
						color = "#5d87bf",
						cterm_color = "59",
						name = "Vlang",
					},
				})
			end

			vim.filetype.add({
				extension = {
					v = "vlang",
					vsh = "vlang",
				},
			})

			require("lspconfig")["v_analyzer"].setup({
				cmd = { "v-analyzer" },
				filetypes = { "vlang", "v", "vsh" },
			})
		end,
	},
	{
		-- Git integration showing changes in sign column
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
		opts = {
			attach_to_untracked = true,
			preview_config = {
				border = "none",
			},
		},
	},
	{
		-- Enhanced quickfix window navigation
		"stevearc/quicker.nvim",
		event = "FileType qf",
		opts = {},
	},
	{
		-- Task runner and job management
		"stevearc/overseer.nvim",
		event = "VeryLazy",
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
					position = "left",
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
		enabled = true,
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
}
