return {
    "folke/zen-mode.nvim",

    config = function()
        require("zen-mode").setup({
            window = {
                width = 120,
                backdrop = 1,
                options = {
                    signcolumn = "no",
                    number = false,
                    foldcolumn = "0",
                },
            },
            plugins = {
                gitsigns = { enabled = false },
            },
        })
    end,
}
