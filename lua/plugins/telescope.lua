return {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    branch = "0.1.x",
    dependencies = {
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            cond = function()
                return vim.fn.executable("make") == 1
            end,
        },
    },
    config = function()
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")
        local telescope = require("telescope")

        telescope.setup({
            defaults = {
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
            extensions = {
                fzf = {},
            },
            pickers = {
                buffers = {
                    previewer = false,
                    theme = "ivy",
                    mappings = {
                        i = {
                            ["<C-d>"] = actions.delete_buffer,
                        },
                    },
                },
                colorscheme = {
                    theme = "ivy",
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

        telescope.load_extension("fzf")
    end,
}
