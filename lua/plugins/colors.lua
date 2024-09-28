return {
    {
        "morhetz/gruvbox",
        config = function()
            vim.cmd([[
                let g:gruvbox_sign_column="bg0"
            ]])
        end,
    },
    "lunacookies/vim-colors-xcode",
    "projekt0n/github-nvim-theme",
    "savq/melange-nvim",
    "folke/tokyonight.nvim",
    "rose-pine/neovim",
    {"navarasu/onedark.nvim", config = function ()
        require('onedark').setup({
            style = "warm"

        })
    end}
}
