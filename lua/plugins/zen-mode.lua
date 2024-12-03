return {
    "folke/zen-mode.nvim",

    config = function()
        require("zen-mode").setup({
            window = {
                width = 80,
                backdrop = 1,
            },
        })

        vim.cmd([[
            highlight! link ZenBg NormalFloat
        ]])
    end,
}
