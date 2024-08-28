return {
    "tpope/vim-fugitive",
    "kdheepak/lazygit.nvim",
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
    "farmergreg/vim-lastplace",
    {
        "echasnovski/mini.surround",
        version = false,
        opts = {},
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
        "ibhagwan/fzf-lua",
        config = function()
            -- calling `setup` is optional for customization
            require("fzf-lua").setup({
                fzf_colors = true,
                winopts = {
                    backdrop = 100,
                },
            })
        end,
    },
}
