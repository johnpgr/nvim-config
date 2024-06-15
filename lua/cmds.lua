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

-- vim.cmd([[
-- 	let g:gruvbox_italic = 0
-- 	let g:gruvbox_contrast_dark = "medium"
-- 	let g:gruvbox_sign_column = "bg0"
-- 	let g:gruvbox_invert_selection = 0
-- ]])

vim.cmd "colorscheme catppuccin"

-- vim.cmd([[
-- 	highlight Normal guibg=none
-- 	highlight NonText guibg=none
-- 	highlight Normal ctermbg=none
-- 	highlight NonText ctermbg=none
-- ]])
vim.cmd [[
    highlight NormalFloat guibg=#1E1E2E
]]
