local M = {}

function M.buffer_fuzzy_find()
    require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown())
end

function M.list_nvim_config_files()
    require("utils.telescope-pretty-pickers").pretty_files_picker {
        picker = "find_files",
        options = {
            cwd = vim.fn.stdpath "config",
            hidden = false,
            disable_devicons = true,
        },
    }
end

function M.list_spell_suggestions_under_cursor()
    require("telescope.builtin").spell_suggest(require("telescope.themes").get_cursor {})
end

function M.grep_string_under_cursor()
    require("utils.telescope-pretty-pickers").pretty_grep_picker {
        picker = "grep_string",
        options = { disable_devicons = true },
    }
end

function M.list_recent_files()
    require("utils.telescope-pretty-pickers").pretty_files_picker {
        picker = "oldfiles",
        options = { only_cwd = true },
    }
end

function M.list_files_cwd()
    require("utils.telescope-pretty-pickers").pretty_files_picker {
        picker = "find_files",
    }
end

function M.live_grep() require("utils.telescope-pretty-pickers").pretty_grep_picker { picker = "live_grep" } end

return M
