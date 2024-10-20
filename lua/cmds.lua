local feedkeys = require("utils").feedkeys
local oil = require("oil")

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

local function currend_oil_path()
    local current_path = oil.get_current_dir()
    local home_dir = vim.fn.expand("~")
    current_path = vim.fn.substitute(current_path or "", home_dir .. "/", "", "")
    return current_path
end

local function current_file_path()
    local current_path = vim.fn.expand("%:p")
    local home_dir = vim.fn.expand("~")
    current_path = vim.fn.substitute(current_path, home_dir .. "/", "", "")
    return current_path
end

vim.api.nvim_create_autocmd("BufWinEnter", {
    callback = function(ev)
        if vim.fn.win_gettype() ~= "" then
            return
        end

        if vim.bo[ev.buf].buftype == "terminal" then
            return
        end

        if vim.bo[ev.buf].filetype == "oil" and vim.api.nvim_get_current_buf() == ev.buf then
            local dir = currend_oil_path()
            vim.api.nvim_set_option_value("winbar", "    " .. dir, { scope = "local", win = 0 })
            vim.cmd([[
                highlight link WinBar OilDir
            ]])
        elseif vim.api.nvim_get_current_buf() == ev.buf then
            local file_path = current_file_path()
            vim.api.nvim_set_option_value("winbar", "    " .. file_path, { scope = "local", win = 0 })
            vim.cmd([[
                highlight link WinBar OilDir
            ]])
        end
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function()
        vim.cmd([[
            highlight DiagnosticUnderlineWarn gui=undercurl
            highlight DiagnosticUnderlineError gui=undercurl
            highlight DiagnosticUnderlineHint gui=undercurl
            highlight DiagnosticUnderlineInfo gui=undercurl
            highlight DiagnosticUnderlineOk gui=undercurl
        ]])
    end,
})
