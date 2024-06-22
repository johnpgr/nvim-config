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
        require("telescope").setup {
            defaults = {
                mappings = {
                    i = {
                        ["<C-u>"] = false,
                    },
                },
            },
            pickers = {
                buffers = {
                    theme = "dropdown",
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
