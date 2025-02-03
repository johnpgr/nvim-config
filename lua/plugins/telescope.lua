local utils = require('utils')
local is_windows = utils.is_windows
local is_neovide = utils.is_neovide

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
    },
    config = function()
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")
        local telescope = require("telescope")

        telescope.setup({
            defaults = {
                layout_strategy = "horizontal",
                layout_config = {
                    horizontal = {
                        prompt_position = "top",
                    },
                },
                sorting_strategy = "ascending",
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
            extensions = is_windows and {} or {
                fzf = {},
            },
            pickers = {
                buffers = {
                    previewer = false,
                    theme = "dropdown",
                    mappings = {
                        n = {
                            ["<C-d>"] = actions.delete_buffer,
                        },
                        i = {
                            ["<C-d>"] = actions.delete_buffer,
                        },
                    },
                },
                find_files = {
                    previewer = false,
                    theme = "dropdown"
                },
                oldfiles = {
                    previewer = false,
                    theme = "dropdown",
                    only_cwd = true,
                },
                colorscheme = {
                    mappings = {
                        i = {
                            ["<CR>"] = function(bufnr)
                                local selection = action_state.get_selected_entry()
                                local new = selection.value
                                local file = io.open(vim.fn.stdpath("config") .. "/lua/colorscheme.lua", "w")

                                actions.close(bufnr)
                                vim.cmd.colorscheme(new)
                                if file then
                                    file:write('vim.cmd.colorscheme("' .. new .. '")')
                                    file:close()
                                end
                            end,
                        },
                    },
                },
            },
        })

        if is_neovide then
            telescope.load_extension('projects')
        end
        if not is_windows then
            telescope.load_extension("fzf")
        end
    end,
}
