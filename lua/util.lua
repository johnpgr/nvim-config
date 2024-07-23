local M = {}

function M.lua_ls_on_init(client)
    local path = vim.tbl_get(client,"workspace_folders", 1, "name")
    if not path then
        vim.print("no workspace")
        return
    end
    client.settings = vim.tbl_deep_extend('force', client.settings, {
        Lua = {
            runtime = {
                version = 'LuaJIT'
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME
                    -- Depending on the usage, you might want to add additional paths here.
                    -- "${3rd}/luv/library"
                    -- "${3rd}/busted/library",
                }
                -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                -- library = vim.api.nvim_get_runtime_file("", true)
            }
        }
    })
end


---Utility for keymap creation.
---@param lhs string
---@param rhs string|function
---@param opts string|table
---@param mode? string|string[]
function M.keymap(lhs, rhs, opts, mode)
    opts = type(opts) == 'string' and { desc = opts }
        or vim.tbl_extend('error', opts --[[@as table]], { buffer = bufnr })
    mode = mode or {'n','v'}
    vim.keymap.set(mode, lhs, rhs, opts)
end

---For replacing certain <C-x>... keymaps.
---@param keys string
function M.feedkeys(keys)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', true)
end

---Is the completion menu open?
function M.pumvisible()
    return tonumber(vim.fn.pumvisible()) ~= 0
end

return M
