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
	event = "VeryLazy",
	dependencies = {
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return not is_windows and vim.fn.executable("make") == 1
			end,
		},
		"nvim-telescope/telescope-ui-select.nvim",
		"nvim-telescope/telescope-file-browser.nvim",
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

		local telescope = require("telescope")
		local builtin = require("telescope.builtin")
		local themes = require("telescope.themes")
		local extensions = {
			file_browser = vim.tbl_extend("force", default_picker_config, {
				prompt_path = true,
				git_status = false,
				hide_parent_dir = true,
				grouped = true,
				dir_icon = "",
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
				require("telescope.themes").get_dropdown(),
			},
		}

		local function grep_current_buffer()
			local original_win = vim.api.nvim_get_current_win()
			local original_bufnr = vim.api.nvim_get_current_buf()

			local action_state = require("telescope.actions.state")
			local actions = require("telescope.actions")

			local opts = vim.tbl_extend("force", default_picker_config, {
				fuzzy = false,
				exact = true,
				attach_mappings = function(prompt_bufnr, map)
					local function jump_to_selection()
						local selection = action_state.get_selected_entry()
						if selection and selection.lnum then
							local line_count = vim.api.nvim_buf_line_count(original_bufnr)

							if selection.lnum > 0 and selection.lnum <= line_count then
								local line = vim.api.nvim_buf_get_lines(
									original_bufnr,
									selection.lnum - 1,
									selection.lnum,
									false
								)[1] or ""
								local col = math.min(selection.col or 0, #line)

								vim.cmd("normal! m'")
								vim.api.nvim_win_set_cursor(original_win, { selection.lnum, col })

								if vim.api.nvim_win_is_valid(original_win) then
									vim.api.nvim_win_call(original_win, function()
										vim.cmd("normal! zz")
									end)
								end
							end
						end
					end

					actions.select_default:replace(function()
						jump_to_selection()
						actions.close(prompt_bufnr)
					end)

					local move_selection_next = function()
						actions.move_selection_next(prompt_bufnr)
						jump_to_selection()
					end

					local move_selection_previous = function()
						actions.move_selection_previous(prompt_bufnr)
						jump_to_selection()
					end

					map("i", "<Down>", move_selection_next)
					map("i", "<C-n>", move_selection_next)
					map("i", "<Up>", move_selection_previous)
					map("i", "<C-p>", move_selection_previous)

					map("n", "j", move_selection_next)
					map("n", "k", move_selection_previous)

					map("i", "<C-q>", function()
						actions.send_to_qflist(prompt_bufnr)
						vim.cmd("copen")
					end)

					map("n", "<C-q>", function()
						actions.send_to_qflist(prompt_bufnr)
						vim.cmd("copen")
					end)

					return true
				end,
				on_input_filter_cb = function(prompt)
					if prompt and #prompt > 0 then
						vim.fn.setreg("/", prompt)
						vim.cmd("let v:hlsearch=1")
					end
					return prompt
				end,
			})
			builtin.current_buffer_fuzzy_find(themes.get_ivy(opts))
		end

		telescope.setup({
			defaults = {
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
                vim_options = default_picker_config,
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

		telescope.grep_current_buffer = grep_current_buffer

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
