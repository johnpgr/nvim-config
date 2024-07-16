return {
    {
        "morhetz/gruvbox",
        config = function()
            vim.cmd [[
                let g:gruvbox_invert_selection=0
                let g:gruvbox_contrast_dark="medium"
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
        "RRethy/base16-nvim",
        config = function()
            require("base16-colorscheme").with_config {
                telescope = true,
                indentblankline = true,
                notify = true,
                ts_rainbow = true,
                cmp = true,
                illuminate = true,
                dapui = true,
            }
        end,
    },
}
