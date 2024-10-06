local feedkeys = require("utils").feedkeys

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
    highlight NormalFloat guibg=#2c2e33
]])

vim.cmd([[
    autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })
]])
