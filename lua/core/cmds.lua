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
    colorscheme xcodedark
    highlight NormalFloat guibg=#393B44
    highlight WinSeparator guifg=#393B44
    highlight link NeoTreeIndentMarker WinSeparator
    highlight NeoTreeFloatBorder guifg=#393B44
    highlight NeoTreeFloatTitle guibg=#393B44
]])

local function transparent()
    vim.cmd([[
        highlight LineNr guibg=none
        highlight FoldColumn guibg=none
        highlight SignColumn guibg=none
        highlight Normal guibg=none
        highlight NonText guibg=none
        highlight Normal ctermbg=none
        highlight NonText ctermbg=none
        set nocursorline
    ]])
end

vim.api.nvim_create_user_command("Transparent", transparent, {})

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

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        vim.defer_fn(function()
            vim.cmd("Neotree toggle")
            feedkeys("<C-w>l")
        end, 1)
    end,
})
