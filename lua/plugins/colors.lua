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
    {
        "navarasu/onedark.nvim",
        config = function()
            require("onedark").setup({
                style = "dark",
                transparent = false,
                term_colors = true,
                ending_tildes = false,
                cmp_itemkind_reverse = false,
                code_style = {
                    comments = "none",
                    keywords = "none",
                    functions = "none",
                    strings = "none",
                    variables = "none",
                },
                lualine = {
                    transparent = false,
                },
                colors = {},
                highlights = {},
                diagnostics = {
                    darker = true,
                    undercurl = true,
                    background = true,
                },
            })
        end,
    },
}
