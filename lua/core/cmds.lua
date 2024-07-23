local feedkeys = require("util").feedkeys

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function() vim.highlight.on_yank() end,
    group = highlight_group,
    pattern = "*",
})

vim.cmd [[
    colorscheme gruvbox
    autocmd TermOpen * startinsert
    autocmd TermOpen * setlocal nonumber norelativenumber
    autocmd TermEnter * setlocal signcolumn=no
    highlight NormalFloat guibg=#504945
    highlight FoldColumn guibg=none
    highlight SignColumn guibg=none
    "highlight Normal guibg=none
    "highlight NonText guibg=none
    "highlight Normal ctermbg=none
    "highlight NonText ctermbg=none
]]

vim.api.nvim_create_user_command("QueryReplace", function()
    local query = vim.fn.input("Query replace:")
    feedkeys("/" .. query .. "<CR><C-o>")
    vim.defer_fn(function()
        local canceledprompt = "AAAAAA"
        local replace = vim.fn.input({ prompt = "Replace " .. query .. " with:", cancelreturn = canceledprompt })
        if replace == canceledprompt then
            return
        end
        feedkeys(":%s/" .. query .. "/" .. replace .. "/g")
    end, 1)
end, {})
