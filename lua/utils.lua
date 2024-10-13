local M = {}

function M.lua_ls_on_init(client)
    local path = vim.tbl_get(client, "workspace_folders", 1, "name")
    if not path then
        vim.print("no workspace")
        return
    end
    client.settings = vim.tbl_deep_extend("force", client.settings, {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                    -- Depending on the usage, you might want to add additional paths here.
                    -- "${3rd}/luv/library"
                    -- "${3rd}/busted/library",
                },
                -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                -- library = vim.api.nvim_get_runtime_file("", true)
            },
        },
    })
end

---Utility for keymap creation.
---@param lhs string
---@param rhs string|function
---@param opts string|table
---@param mode? string|string[]
function M.keymap(lhs, rhs, opts, mode)
    opts = type(opts) == "string" and { desc = opts }
        or vim.tbl_extend("error", opts --[[@as table]], { buffer = bufnr })
    mode = mode or { "n", "v" }
    vim.keymap.set(mode, lhs, rhs, opts)
end

---For replacing certain <C-x>... keymaps.
---@param keys string
function M.feedkeys(keys)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "n", true)
end

function M.toggle_spaces_width()
    local currentWidth = vim.opt.shiftwidth:get()
    local currentTabstop = vim.opt.tabstop:get()

    if currentWidth == 2 and currentTabstop == 2 then
        vim.opt.shiftwidth = 4
        vim.opt.tabstop = 4
    else
        vim.opt.shiftwidth = 2
        vim.opt.tabstop = 2
    end
    -- Print a message to indicate the current values
    print("Shiftwidth: " .. vim.opt.shiftwidth:get() .. " Tabstop: " .. vim.opt.tabstop:get())
end

function M.toggle_indent_mode()
    -- Get the current buffer number
    local bufnr = vim.fn.bufnr()

    -- Get the current value of 'expandtab' (whether spaces are being used)
    local expandtab = vim.bo.expandtab

    if expandtab then
        -- If spaces are being used, toggle to tabs
        vim.bo.expandtab = false
    else
        -- If tabs are being used, toggle to spaces
        vim.bo.expandtab = true
    end

    -- Get the updated values of 'tabstop' and 'shiftwidth' after toggling
    local tabstop = vim.bo.tabstop
    local shiftwidth = vim.bo.shiftwidth

    -- Retab the buffer to apply the changes
    vim.fn.execute("retab!")

    -- Display a message indicating the toggle is done
    local current_mode = vim.bo.expandtab == true and "Spaces" or "Tabs"
    print("Current indentation mode: " .. current_mode)
end

return M
