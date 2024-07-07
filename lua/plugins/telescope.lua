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
