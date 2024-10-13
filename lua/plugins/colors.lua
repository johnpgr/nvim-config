return {
    {
        "rebelot/kanagawa.nvim",
        opts = { compile = true, commentStyle = { italic = false }, keywordStyle = { italic = false } },
    },
    { "water-sucks/darkrose.nvim" },
    { "folke/tokyonight.nvim", opts = {} },
    { "catppuccin/nvim", name = "catppuccin" },
    {
        "scottmckendry/cyberdream.nvim",
        config = function()
            require("cyberdream").setup({
                transparent = false,
                italic_comments = false,
                hide_fillchars = false,
                borderless_telescope = false,
            })
        end,
    },
}
