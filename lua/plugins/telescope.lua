local utils = require("utils")
local is_windows = utils.is_windows
local is_neovide = utils.is_neovide

local function persist_colorscheme(bufnr)
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	local selection = action_state.get_selected_entry()
	local new = selection.value
	local json_file = vim.fn.stdpath("config") .. "/colorscheme.json"

	actions.close(bufnr)
	-- Try to set the colorscheme first
	local ok = pcall(vim.cmd.colorscheme, new)
	if ok then
		-- Only save if the colorscheme was successfully set
		local file = io.open(json_file, "w")
		if file then
			file:write(vim.json.encode({ colorscheme = new }))
			file:close()
		end
	end
end

return {
	"nvim-telescope/telescope.nvim",
	event = "VeryLazy",
	-- branch = "0.1.x",
	dependencies = {
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return not is_windows and vim.fn.executable("make") == 1
			end,
		},
		"nvim-telescope/telescope-ui-select.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local extensions = {
			fzf = {},
			textcase = {},
			["ui-select"] = {
				require("telescope.themes").get_dropdown(),
			},
		}

		local default_picker_config = {
			theme = "ivy",
			previewer = false,
			layout_config = {
				height = 0.3,
			},
		}

		telescope.setup({
			defaults = {
				results_title = false,
				path_display = {
					filename_first = {
						reverse_directories = false,
					},
				},
				mappings = {
					i = {
						["<C-u>"] = false,
						["<C-q>"] = function(bufnr)
							require("telescope.actions").send_to_qflist(bufnr)
							vim.cmd("copen")
						end,
					},
				},
			},
			extensions = is_windows and {} or extensions,
			pickers = {
				buffers = vim.tbl_extend("force", default_picker_config, {
					mappings = {
						n = {
							["<C-d>"] = require("telescope.actions").delete_buffer,
						},
						i = {
							["<C-d>"] = require("telescope.actions").delete_buffer,
						},
					},
				}),
				find_files = default_picker_config,
				live_grep = default_picker_config,
				oldfiles = vim.tbl_extend("force", default_picker_config, {
					only_cwd = true,
				}),
				colorscheme = vim.tbl_extend("force", default_picker_config, {
					mappings = {
						n = {
							["<CR>"] = persist_colorscheme,
						},
						i = {
							["<CR>"] = persist_colorscheme,
						},
					},
				}),
				help_tags = default_picker_config,
				commands = default_picker_config,
                spell_suggest = default_picker_config,
                reloader = default_picker_config,
			},
		})

		if is_neovide then
			telescope.load_extension("projects")
		end
		if not is_windows then
			telescope.load_extension("fzf")
		end

		telescope.load_extension("textcase")
		telescope.load_extension("ui-select")
	end,
}
