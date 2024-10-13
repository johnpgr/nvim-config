return {
    "tpope/vim-fugitive",
    "kdheepak/lazygit.nvim",
    "xiyaowong/transparent.nvim",
    "farmergreg/vim-lastplace",
    "nvim-tree/nvim-web-devicons",
    { "nvchad/volt", lazy = true },
    { "nvchad/menu", lazy = true },
    {
        "nvchad/ui",
        config = function()
            require("nvchad")
        end,
    },
    {
        "nvchad/base46",
        lazy = true,
        build = function()
            require("base46").load_all_highlights()
        end,
    },
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
        "johmsalas/text-case.nvim",
        config = function()
            require("textcase").setup({
                prefix = "tc",
                substitude_command_name = "S",
            })
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()
        end,
    },
    {
        "mg979/vim-visual-multi",
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
        "echasnovski/mini.surround",
        version = false,
        config = function()
            require("mini.surround").setup()
        end,
    },
    {
        "echasnovski/mini.align",
        version = false,
        config = function()
            require("mini.align").setup()
        end,
    },
    {
        "nvim-pack/nvim-spectre",
        lazy = true,
        cmd = { "Spectre" },
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("spectre").setup({
                highlight = {
                    search = "SpectreSearch",
                    replace = "SpectreReplace",
                },
                mapping = {
                    ["send_to_qf"] = {
                        map = "<C-q>",
                        cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
                        desc = "send all items to quickfix",
                    },
                },
            })
        end,
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {},
    },
    {
        "nvimdev/indentmini.nvim",
        enabled = false,
        config = function()
            require("indentmini").setup()
        end,
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
        "ejrichards/mise.nvim",
        opts = {},
    },
    {
        "lukas-reineke/virt-column.nvim",
        opts = {
            char = { "│" },
            virtcolumn = "80",
            highlight = { "NonText" },
        },
    },
}
