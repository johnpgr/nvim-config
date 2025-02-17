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
                inverse = true, -- invert background for search, diffs, statuslines and errors
                contrast = "hard", -- can be "hard", "soft" or empty string
                palette_overrides = {
                    bright_orange = "#ebdbb2", -- Remove oranges
                },
                overrides = {},
                dim_inactive = false,
                transparent_mode = false,
            })
        end,
    },
    "sainnhe/gruvbox-material",
    "folke/tokyonight.nvim",
    "catppuccin/nvim",
    "felipeagc/fleet-theme-nvim",
    "sainnhe/everforest",
    "rjshkhr/shadow.nvim",
    "CreaturePhil/vim-handmade-hero",
}
