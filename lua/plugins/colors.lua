return {
    {
        "morhetz/gruvbox",
        config = function()
            vim.cmd [[
                let g:gruvbox_invert_selection=0
                let g:gruvbox_contrast_dark="hard"
                let g:gruvbox_sign_column="bg0"
            ]]
        end,
    },
    {
        "catppuccin/nvim",
        config = function()
            require("catppuccin").setup {
                no_italic = true,
            }
        end,
    },
    {
        "blazkowolf/gruber-darker.nvim",
        opts = {
            bold = true,
            invert = {
                signs = false,
                tabline = false,
                visual = false,
            },
            italic = {
                strings = false,
                comments = false,
                operators = false,
                folds = false,
            },
            undercurl = true,
            underline = true,
        },
    },
    {
        "zenbones-theme/zenbones.nvim",
        dependencies = { "rktjmp/lush.nvim" },
    },
}
