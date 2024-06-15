local M = {}

function M.buffer_fuzzy_find()
	require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown())
end

function M.list_nvim_config_files()
	require("utils.pretty-telescope").pretty_files_picker({
		picker = "find_files",
		options = {
			cwd = vim.fn.stdpath("config"),
			hidden = false,
			disable_devicons = true,
		},
	})
end

function M.list_spell_suggestions_under_cursor()
	require("telescope.builtin").spell_suggest(require("telescope.themes").get_cursor({}))
end

function M.grep_string_under_cursor()
	require("utils.pretty-telescope").pretty_grep_picker({
		picker = "grep_string",
		options = { disable_devicons = true },
	})
end

local telescope_dropdown_picker = {
	previewer = false,
	border = true,
	borderchars = {
		prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
		results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
		preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
	},
	layout_strategy = "center",
	results_title = false,
	sorting_strategy = "ascending",
}

function M.list_recent_files()
	require("utils.pretty-telescope").pretty_files_picker({
		picker = "oldfiles",
		options = vim.tbl_extend("force", telescope_dropdown_picker, { only_cwd = true }),
	})
end

function M.list_files_cwd()
	require("utils.pretty-telescope").pretty_files_picker({
		picker = "find_files",
		options = telescope_dropdown_picker,
	})
end

function M.live_grep()
	require("utils.pretty-telescope").pretty_grep_picker({ picker = "live_grep" })
end

return M
