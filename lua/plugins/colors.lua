return {
    {
        "ellisonleao/gruvbox.nvim",
        config = function()
            require("gruvbox").setup({
                terminal_colors = true,
                undercurl = true,
                underline = true,
                bold = false,
                italic = {
                    strings = false,
                    emphasis = false,
                    comments = false,
                    operators = false,
                    folds = false,
                },
                strikethrough = true,
                invert_selection = true,
                invert_signs = false,
                invert_tabline = false,
                invert_intend_guides = false,
                inverse = true,
                contrast = "hard",
                palette_overrides = {
                    bright_orange = "#ebdbb2", -- Remove oranges
                },
                overrides = {
                    SignColumn = { bg = "#1d2021" },
                },
                dim_inactive = false,
                transparent_mode = false,
            })
        end,
    },
    "vinitkumar/oscura-vim",
    "sainnhe/gruvbox-material",
    "folke/tokyonight.nvim",
    "catppuccin/nvim",
    "felipeagc/fleet-theme-nvim",
    "sainnhe/everforest",
    "rjshkhr/shadow.nvim",
    "CreaturePhil/vim-handmade-hero",
}
