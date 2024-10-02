local feedkeys = require("util").feedkeys

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
]])

vim.cmd([[
    colorscheme gruvbox
    highlight NormalFloat guibg=#504945
]])


-- vim.cmd([[
--     colorscheme gruvbox
--     highlight NormalFloat guibg=#504945
-- ]])

-- vim.cmd([[
--     colorscheme xcodedark
--     highlight NormalFloat guibg=#393B44
--     highlight WinSeparator guifg=#393B44
--     highlight link NeoTreeIndentMarker WinSeparator
--     highlight NeoTreeFloatBorder guifg=#393B44
--     highlight NeoTreeFloatTitle guibg=#393B44
-- ]])
