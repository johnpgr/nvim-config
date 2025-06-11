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
	local ok = pcall(vim.cmd.colorscheme, new)
	if ok then
		local file = io.open(json_file, "w")
		if file then
			file:write(vim.json.encode({ colorscheme = new }))
			file:close()
		end
	end
end

return {
	"nvim-telescope/telescope.nvim",
	cmd = { "Telescope" },
	dependencies = {
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return not is_windows and vim.fn.executable("make") == 1
			end,
		},
		"nvim-telescope/telescope-ui-select.nvim",
		{ "johnpgr/telescope-file-browser.nvim", branch = "absolute-path-prompt-prefix" },
	},
	config = function()
		local default_picker_config = {
			theme = "ivy",
			previewer = false,
			layout_config = {
				height = 0.3,
			},
			results_title = false,
		}

		if not vim.g.nerdicons_enable then
			default_picker_config.disable_devicons = true
		end

		local telescope = require("telescope")
		local builtin = require("telescope.builtin")
		local themes = require("telescope.themes")
		local extensions = {
			file_browser = vim.tbl_extend("force", default_picker_config, {
				path = "%:p:h",
				prompt_path = true,
				git_status = false,
				hide_parent_dir = true,
				grouped = true,
				dir_icon = vim.g.nerdicons_enable and "" or "",
				dir_icon_hl = "OilDirIcon",
				mappings = {
					i = {
						["<Tab>"] = function(bufnr)
							local action_state = require("telescope.actions.state")
							local fb_actions = require("telescope").extensions.file_browser.actions
							local entry = action_state.get_selected_entry()
							local entry_path = entry.Path

							if entry_path:is_dir() then
								fb_actions.open_dir(bufnr, nil, entry.path)
							else
								local picker = action_state.get_current_picker(bufnr)
								picker:set_prompt(entry.ordinal)
							end
						end,
					},
				},
			}),
			fzf = {},
			textcase = {},
			["ui-select"] = {
				require("telescope.themes").get_ivy({
					layout_config = default_picker_config.layout_config,
					previewer = default_picker_config.previewer,
					results_title = default_picker_config.results_title,
				}),
			},
		}

		telescope.setup({
			defaults = {
				mappings = {
					i = {
						["<C-u>"] = false,
						["<C-q>"] = function(bufnr)
							require("telescope.actions").send_to_qflist(bufnr)
							vim.cmd("copen")
						end,
                        ["<C-l>"] = function(bufnr)
                            local actions = require("telescope.actions")
                            local action_state = require("telescope.actions.state")
                            local entry = action_state.get_selected_entry()
                            if entry then
                                actions.close(bufnr)
                                vim.cmd("vsplit " .. entry.path or entry.filename or entry.value)
                            end
                        end,

                        ["<C-h>"] = function(bufnr)
                            local actions = require("telescope.actions")
                            local action_state = require("telescope.actions.state")
                            local entry = action_state.get_selected_entry()
                            if entry then
                                actions.close(bufnr)
                                vim.cmd("leftabove vsplit " .. (entry.path or entry.filename or entry.value))
                            end
                        end
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
				vim_options = default_picker_config,
				oldfiles = vim.tbl_extend("force", default_picker_config, {
					only_cwd = true,
				}),
				colorscheme = vim.tbl_extend("force", default_picker_config, {
                    enable_preview = true,
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
                current_buffer_fuzzy_find = default_picker_config,
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
		telescope.load_extension("file_browser")
	end,
}
