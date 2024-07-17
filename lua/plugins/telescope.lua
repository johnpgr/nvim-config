return {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    branch = "0.1.x",
    dependencies = {
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            cond = function() return vim.fn.executable "make" == 1 end,
        },
        {
            "johmsalas/text-case.nvim",
            config = function() require("textcase").setup {} end,
        },
        { "nvim-telescope/telescope-ui-select.nvim" },
    },
    config = function()
        local actions = require "telescope.actions"
        local action_state = require("telescope.actions.state")
        local buffer_previewer = require "utils.telescope-buffer-previewer"
        local image = require "utils.image-previewer"
        buffer_previewer.teardown = image.teardown

        require("telescope").setup {
            defaults = {
                mappings = {
                    i = {
                        ["<C-u>"] = false,
                    },
                },
                buffer_previewer_maker = image.buffer_previewer_maker,
                file_previewer = buffer_previewer.cat.new,
            },
            extensions = { file_browser = { hijack_netrw = true } },
            pickers = {
                buffers = {
                    initial_mode = "normal",
                    theme = "dropdown",
                    mappings = {
                        n = {
                            ["<C-d>"] = actions.delete_buffer,
                        },
                    },
                },
                colorscheme = {
                    enable_preview = true,
                    mappings = {
                        i = {
                            ['<CR>'] = function(bufnr)
                                local selection = action_state.get_selected_entry()
                                local new = selection.value
                                local file = io.open(vim.fn.stdpath('config') .. '/lua/config/colorscheme.lua', 'w')

                                actions.close(bufnr)
                                vim.cmd.colorscheme(new)
                                if file then
                                    file:write('vim.cmd.colorscheme("' .. new .. '")')
                                    file:close()
                                end
                            end
                        }
                    },
                }
            },
        }
    end,
    init = function()
        local t = require "telescope"
        t.load_extension "fzf"
        t.load_extension "textcase"
        t.load_extension "ui-select"
    end,
}
