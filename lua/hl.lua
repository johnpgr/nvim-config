local function hl(name, tbl)
    vim.api.nvim_set_hl(0, name, tbl)
end

hl("DapBreakpoint", { fg = "#FF4C4C" }) -- bright red for normal breakpoints
hl("DapBreakpointCondition", { fg = "#FFB74C" }) -- orange for conditional breakpoints
hl("DapBreakpointRejected", { fg = "#767676" }) -- gray for rejected/invalid breakpoints
hl("DapLogPoint", { fg = "#61AFEF" }) -- blue for logpoints
hl("DapStopped", { fg = "#61AFEF" }) -- blue for stopped threads
hl("NormalFloat", { bg = "#292929" }) -- fleet theme float background

vim.cmd([[
    hi! link WinBar OilDir
    hi! link NormalFloat Pmenu
    " hi! WinSeparator guibg=none
    " hi! VertSplit guibg=none
    " hi! link NeogitWinSeparator WinSeparator
    " hi! FloatBorder guifg=#292929
    " hi! FloatBorder guibg=#292929
    " hi! CursorLineNr guifg=#ffffff
    " hi! CursorLineFold guibg=#292929
]])

-- vim.cmd([[
--     highlight! ZenBg guibg=#212121
-- ]])
