return {
    "tpope/vim-fugitive",
    "kdheepak/lazygit.nvim",
    {
        "xiyaowong/transparent.nvim",
        config = function()
            require("transparent").setup({
                extra_groups = {
                    "NeoTreeNormal",
                    "NeoTreeNormalNC",
                    "NormalFloat",
                },
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
    {
        "echasnovski/mini.align",
        version = false,
        config = function()
            require("mini.align").setup()
        end,
    },
    {
        "stevearc/oil.nvim",
        opts = {
            columns = {
                "icon",
                "size",
                "mtime",
            },
            skip_confirm_for_simple_edits = true,
            keymaps = {
                ["?"] = "actions.show_help",
                ["<CR>"] = "actions.select",
                ["<leader>v"] = {
                    "actions.select",
                    opts = { vertical = true },
                    desc = "Open the entry in a vertical split",
                },
                ["<leader>h"] = {
                    "actions.select",
                    opts = { horizontal = true },
                    desc = "Open the entry in a horizontal split",
                },
                ["<leader>tn"] = { "actions.select", opts = { tab = true }, desc = "Open the entry in new tab" },
                ["<leader>p"] = "actions.preview",
                ["<leader>q"] = "actions.close",
                ["<leader>r"] = "actions.refresh",
                ["<backspace>"] = "actions.parent",
                ["_"] = "actions.open_cwd",
                ["`"] = "actions.cd",
                ["~"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to the current oil directory" },
                ["gs"] = "actions.change_sort",
                ["<leader>x"] = "actions.open_external",
                ["H"] = "actions.toggle_hidden",
                ["g\\"] = "actions.toggle_trash",
            },
            use_default_keymaps = false,
            watch_for_changes = true,
        },
    },
    {
        "nanozuki/tabby.nvim",
        event = 'VimEnter',
        config = function()
            require("tabby").setup({
                preset = "tab_only",
                option = {
                    lualine_theme = "ayu_light"
                }
            })
        end,
    },
}
