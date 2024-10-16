return {
    "stevearc/oil.nvim",
    enabled = true,
    opts = {
        columns = {
            "permissions",
            "size",
            "ctime",
            "icon",
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

        view_options = {
            show_hidden = true,
        },
        use_default_keymaps = false,
        watch_for_changes = true,
    },
}
