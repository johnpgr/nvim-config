return {
    "morhetz/gruvbox",
    {
        "kvrohit/rasmus.nvim",
        init = function()
            vim.g.rasmus_italic_comments = false
            vim.g.rasmus_italic_keywords = false
            vim.g.rasmus_italic_booleans = false
            vim.g.rasmus_italic_functions = false
            vim.g.rasmus_italic_variables = false
            vim.g.rasmus_bold_comments = false
            vim.g.rasmus_bold_keywords = false
            vim.g.rasmus_bold_booleans = false
            vim.g.rasmus_bold_functions = false
            vim.g.rasmus_bold_variables = false
        end,
    },
    "sainnhe/gruvbox-material",
    "RRethy/base16-nvim",
    {
        "rebelot/kanagawa.nvim",
        opts = { compile = true, commentStyle = { italic = false }, keywordStyle = { italic = false } },
    },
    "folke/tokyonight.nvim",
    "catppuccin/nvim",
    "felipeagc/fleet-theme-nvim",
    "sainnhe/everforest",
}
