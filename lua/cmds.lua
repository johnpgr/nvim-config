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
  autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })
]])

function OilDir() return require("oil").get_current_dir() end

vim.api.nvim_create_autocmd("BufWinEnter", {
    callback = function(ev)
        if vim.bo[ev.buf].filetype == "oil" and vim.api.nvim_get_current_buf() == ev.buf then
            vim.api.nvim_set_option_value("winbar", "    %{%v:lua.OilDir()%}:", { scope = "local", win = 0 })
            vim.cmd([[
                highlight link WinBar OilDir
            ]])
        end
    end,
})
