-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = "*",
})

vim.cmd([[
    autocmd TermOpen * startinsert
    autocmd TermOpen * setlocal nonumber norelativenumber
    autocmd TermEnter * setlocal signcolumn=no
    autocmd TermEnter * setlocal nospell
]])

vim.cmd([[
    autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })
]])

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client then
            client.server_capabilities.semanticTokensProvider = nil
        end
        vim.cmd([[
            highlight DiagnosticUnderlineWarn gui=undercurl
            highlight DiagnosticUnderlineError gui=undercurl
            highlight DiagnosticUnderlineHint gui=undercurl
            highlight DiagnosticUnderlineInfo gui=undercurl
            highlight DiagnosticUnderlineOk gui=undercurl
        ]])
    end,
})

-- Function to align text based on a given token
local function align_text(token, lines)
    local max_pos = 0

    -- Find the maximum position of the token in any line
    for _, line in ipairs(lines) do
        local pos = line:find(token)
        if pos and pos > max_pos then
            max_pos = pos
        end
    end

    -- Align each line based on the token position
    local aligned_lines = {}
    for _, line in ipairs(lines) do
        local pos = line:find(token)
        if pos then
            local spaces_to_add = max_pos - pos
            local aligned_line = line:sub(1, pos - 1) .. string.rep(" ", spaces_to_add) .. line:sub(pos)
            table.insert(aligned_lines, aligned_line)
        else
            table.insert(aligned_lines, line)
        end
    end

    return aligned_lines
end

-- Create a Neovim command to call the align_text function
vim.api.nvim_create_user_command("Align", function(opts)
    local token = opts.args
    if #token ~= 1 then
        print("Error: Token must be a single character.")
        return
    end
    local start_line = opts.line1
    local end_line = opts.line2
    local lines = vim.fn.getline(start_line, end_line)
    local aligned_lines = align_text(token, lines)
    vim.fn.setline(start_line, aligned_lines)
end, {
    nargs = 1,
    range = true,
    complete = function()
        return {}
    end,
})
