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
            ["<F1>"] = function()
                local oil = require("oil")
                local entry = oil.get_cursor_entry()
                local cwd = oil.get_current_dir()

                if not entry then
                    return
                end

                vim.ui.input({ prompt = "Enter command: " }, function(cmd)
                    if cmd then
                        local full_path = cwd .. entry.name
                        local res = vim.system({ cmd, full_path }, { text = true }):wait()

                        -- Create a new scratch buffer in a new window
                        vim.cmd("botright new")
                        local buf = vim.api.nvim_get_current_buf()

                        -- Set buffer options
                        vim.bo[buf].buftype = "nofile"
                        vim.bo[buf].bufhidden = "wipe"
                        vim.bo[buf].swapfile = false

                        local opts = { buffer = buf, noremap = true, silent = true }
                        vim.keymap.set("n", "q", ":close<CR>", opts)
                        vim.keymap.set("n", "<C-c>", ":close<CR>", opts)
                        vim.keymap.set("n", "<ESC>", ":close<CR>", opts)

                        -- Add the output to the buffer
                        if res.stderr and res.stderr ~= "" then
                            vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(res.stderr, "\n"))
                        end
                        if res.stdout and res.stdout ~= "" then
                            vim.api.nvim_buf_set_lines(buf, -1, -1, false, vim.split(res.stdout, "\n"))
                        end
                    end
                end)
            end,
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
