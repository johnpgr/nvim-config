-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function() vim.highlight.on_yank() end,
    group = highlight_group,
    pattern = "*",
})

-- Forward a command output to a temp buffer
vim.api.nvim_create_user_command("F", function(ctx)
    local lines = vim.split(vim.api.nvim_exec(ctx.args, true), "\n", { plain = true })
    table.remove(lines, 1)
    table.remove(lines, 1)

    vim.cmd "new"
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.opt_local.modified = false
end, { nargs = "+", complete = "command" })

require("nvim-web-devicons").set_icon {
    v = {
        icon = "",
        color = "#4b6c88",
        cterm_color = "24",
        name = "Vlang",
    },
}

vim.cmd [[
    " highlight NormalFloat guibg=#121212
    " highlight FoldColumn guibg=#282828
]]

local ts_overrides = {
    on_attach = function(client, bufnr)
        require("twoslash-queries").attach(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
    end,
}

local lsp_client_overrides = {
    tsserver = ts_overrides,
    ["typescript-tools"] = ts_overrides,
}

vim.api.nvim_create_autocmd({ "LspAttach" }, {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then return end

        local overrides = lsp_client_overrides[client.name]
        if not overrides then return end
        overrides.on_attach(client, args.buf)
    end,
})

-- Terminal mode
vim.cmd [[
    autocmd TermOpen * startinsert
    autocmd TermOpen * setlocal nonumber norelativenumber
    autocmd TermEnter * setlocal signcolumn=no
]]
