-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = "*",
})

-- Better terminal buffer
vim.cmd([[
    autocmd TermOpen * startinsert
    autocmd TermOpen * setlocal nonumber norelativenumber
    autocmd TermEnter * setlocal signcolumn=no
    autocmd TermEnter * setlocal nospell
]])

-- Vim dadbod
vim.cmd([[
    autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })
]])

-- Make undercurls work properly
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        -- local client = vim.lsp.get_client_by_id(args.data.client_id)
        -- if client then
        --     client.server_capabilities.semanticTokensProvider = nil
        -- end
        vim.cmd([[
            highlight DiagnosticUnderlineError gui=undercurl
            highlight DiagnosticUnderlineHint gui=undercurl
            highlight DiagnosticUnderlineInfo gui=undercurl
            highlight DiagnosticUnderlineOk gui=undercurl
            highlight DiagnosticUnderlineWarn gui=undercurl
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

-- set makeprg and errorformat for GCC in {.c, .h} files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    callback = function()
        local file_path = vim.fn.expand("%:p")
        local file_name = vim.fn.expand("%:t")
        local out_path = vim.fn.expand("%:p:h"):gsub("src", "out") .. "/" .. file_name:gsub("%.c$", "")
        local GCC_ARGS = "-Wall -Wextra -Werror -Wpedantic -std=c2x -lm -o " .. out_path

        vim.bo.makeprg = "gcc " .. GCC_ARGS .. " " .. file_path
        vim.bo.errorformat = "%f:%l:%c: %t%*[^:]%m"
    end,
    pattern = "*.c",
})

vim.api.nvim_create_user_command("CRun", function()
    vim.cmd("make")

    if vim.v.shell_error == 0 then
        local file_name = vim.fn.expand("%:t"):gsub("%.c$", "")
        local out_path = vim.fn.expand("%:p:h"):gsub("src", "out") .. "/" .. file_name

        vim.cmd(string.format("split | terminal %s", out_path))
    end
end, {
    desc = "Compile and run C file",
})

vim.api.nvim_create_user_command('Grep', function(opts)
    vim.cmd('silent grep! ' .. opts.args)
    vim.cmd('cwindow')
end, { nargs = '+' })

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown" },
    callback = function()
        local cmp = require("cmp")
        cmp.setup.buffer({
            completion = {
                autocomplete = false
            }
        })
    end,
})
