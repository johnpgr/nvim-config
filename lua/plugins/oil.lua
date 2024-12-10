-- Declare a global function to retrieve the current directory
function _G.get_oil_winbar()
    local dir = require("oil").get_current_dir()
    if dir then
        return vim.fn.fnamemodify(dir, ":~")
    else
        -- If there is no current directory (e.g. over ssh), just show the buffer name
        return vim.api.nvim_buf_get_name(0)
    end
end

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
            ["q"] = "actions.close",
            ["<RightMouse>"] = "<LeftMouse><cmd>lua require('oil.actions').select.callback()<CR>",
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
            ["<leader>p"] = "actions.preview",
            ["<F5>"] = "actions.refresh",
            ["<backspace>"] = "actions.parent",
            ["_"] = "actions.open_cwd",
            ["`"] = "actions.cd",
            ["~"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to the current oil directory" },
            ["gs"] = "actions.change_sort",
            ["<leader>x"] = "actions.open_external",
            ["H"] = "actions.toggle_hidden",
            ["g\\"] = "actions.toggle_trash",
        },
        win_options = {
            winbar = "%!v:lua.get_oil_winbar()",
        },
        view_options = {
            -- show_hidden = true,
        },
        use_default_keymaps = false,
        watch_for_changes = true,
    },
}
