return {
    "tpope/vim-fugitive",
    "kdheepak/lazygit.nvim",
    "xiyaowong/transparent.nvim",
    "farmergreg/vim-lastplace",
    "nvim-tree/nvim-web-devicons",
    {
        "crnvl96/lazydocker.nvim",
        event = "VeryLazy",
        opts = {
            popup_window = {
                border = {
                    highlight = "Normal",
                },
            },
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
    },
    {
        "mg979/vim-visual-multi",
        event = "BufRead",
        config = function()
            vim.cmd([[
            let g:VM_maps = {}
            let g:VM_maps["Goto Prev"] = "\[\["
            let g:VM_maps["Goto Next"] = "\]\]"
            "Select all occurrences under cursor
            nmap <C-M-n> <Plug>(VM-Select-All)
        ]])
        end,
    },
    {
        "echasnovski/mini.surround",
        event = "BufRead",
        version = false,
        config = function()
            require("mini.surround").setup()
        end,
    },
    {
        "johmsalas/text-case.nvim",
        config = function()
            require("textcase").setup({
                prefix = "tc",
                substitude_command_name = "S",
            })
        end,
    },
    {
        "nvimdev/indentmini.nvim",
        enabled = false,
        config = function()
            require("indentmini").setup()
        end,
    },
    {
        "echasnovski/mini.comment",
        event = "VeryLazy",
        dependencies = {
            {
                "JoosepAlviste/nvim-ts-context-commentstring",
                lazy = true,
                opts = {
                    enable_autocmd = false,
                },
            },
        },
        opts = {
            options = {
                custom_commentstring = function()
                    return require("ts_context_commentstring.internal").calculate_commentstring()
                        or vim.bo.commentstring
                end,
            },
            mappings = {
                comment_line = "gcc",
                comment_visual = "gc",
            },
        },
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {},
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && npm install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    },
    {
        "ollykel/v-vim",
        init = function()
            require("nvim-web-devicons").set_icon({
                v = {
                    icon = "",
                    color = "#5d87bf",
                    cterm_color = "59",
                    name = "Vlang",
                },
                vsh = {
                    icon = "",
                    color = "#5d87bf",
                    cterm_color = "59",
                    name = "Vlang",
                },
            })

            vim.filetype.add({
                extension = {
                    v = "vlang",
                    vsh = "vlang",
                },
            })

            require("lspconfig")["v_analyzer"].setup({
                cmd = { "v-analyzer" },
                filetypes = { "vlang", "v", "vsh" },
            })
        end,
    },
    { "joerdav/templ.vim" },
    {
        "lewis6991/gitsigns.nvim",
        event = "VeryLazy",
        opts = {
            attach_to_untracked = true,
            preview_config = {
                border = "none",
            },
        },
    },
    {
        "mcauley-penney/visual-whitespace.nvim",
        event = "VeryLazy",
        config = true,
    },
    {
        "stevearc/quicker.nvim",
        event = "FileType qf",
        opts = {},
    },
    {
        "stevearc/overseer.nvim",
        opts = {},
    },
    {
        "stevearc/dressing.nvim",
        opts = {},
    },
}
