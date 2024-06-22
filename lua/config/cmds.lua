-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function() vim.highlight.on_yank() end,
    group = highlight_group,
    pattern = "*",
})

require("nvim-web-devicons").set_icon {
    v = {
        icon = "",
        color = "#4b6c88",
        cterm_color = "24",
        name = "Vlang",
    },
}

vim.cmd [[
    colorscheme seoulbones
]]

vim.cmd [[
    highlight Normal guibg=none
    highlight NonText guibg=none
    highlight Normal ctermbg=none
    highlight NonText ctermbg=none
]]

local ts_overrides = {
    on_attach = function(client, bufnr)
        require("twoslash-queries").attach(client, bufnr)
        -- this is important, otherwise tsserver will format ts/js
        -- files which we *really* don't want.
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
