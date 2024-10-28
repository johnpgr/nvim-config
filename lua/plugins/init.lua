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
        "nvim-pack/nvim-spectre",
        event = "VeryLazy",
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
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && npm install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    },
}
