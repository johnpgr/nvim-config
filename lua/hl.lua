local function sethl(name, tbl)
    vim.api.nvim_set_hl(0, name, tbl)
end

sethl("DapBreakpoint", { fg = "#FF4C4C" }) -- bright red for normal breakpoints
sethl("DapBreakpointCondition", { fg = "#FFB74C" }) -- orange for conditional breakpoints
sethl("DapBreakpointRejected", { fg = "#767676" }) -- gray for rejected/invalid breakpoints
sethl("DapLogPoint", { fg = "#61AFEF" }) -- blue for logpoints
sethl("DapStopped", { fg = "#61AFEF" }) -- blue for stopped threads

vim.cmd([[
    hi IndentLine guifg=#64594f
    hi IndentLineCurrent guifg=#64594f
    hi DiagnosticUnderlineError gui=undercurl
    hi DiagnosticUnderlineHint gui=undercurl
    hi DiagnosticUnderlineInfo gui=undercurl
    hi DiagnosticUnderlineOk gui=undercurl
    hi DiagnosticUnderlineWarn gui=undercurl
    hi WinBar guibg=none
    hi link NeogitWinSeparator WinSeparator
    hi VertSplit guibg=none
    hi OverseerTaskBorder guibg=none
    hi SignColumn guibg=none
    hi FloatBorder guibg=none
    hi FoldColumn guibg=none
<<<<<<< HEAD
    hi GitGutterAdd guibg=none
    hi GitGutterChange guibg=none
    hi GitGutterDelete guibg=none
    hi GitGutterChangeDelete guibg=none
    " Handmade hero colorscheme hl fixes
    hi CursorLine guibg=#17196d
    hi StatusLine guibg=#bebebe
    hi Normal guibg=none
=======
    hi CursorLine guibg=#00008b
    " hi GitGutterAdd guibg=none
    " hi GitGutterChange guibg=none
    " hi GitGutterDelete guibg=none
    " hi GitGutterChangeDelete guibg=none
    " hi CursorLine guibg=#17196d
    " hi StatusLine guibg=#bebebe
>>>>>>> e1471df (Sync 22-03-25)
    hi Operator guibg=none
    hi @property guibg=none
    hi NonText guibg=none
    hi DapUIVariable guibg=none
    hi DapUIValue guibg=none
    hi DapUIFrameName guibg=none
    " hi Special ctermfg=172 guifg=#cd950c
    " hi link DiagnosticSignWarn GruvboxYellow
    " hi link DiagnosticSignError GruvboxRed
    " hi link DiagnosticSignOk GruvboxBlue
    " hi link DiagnosticSignHint GruvboxAqua
    " hi TelescopePromptPrefix guibg=none
    " hi TelescopePromptNormal guibg=#000000 
    " hi TelescopePromptBorder guibg=#000000 guifg=#000000
    " hi Comment guifg=#595959
    " hi TSComment guifg=#595959
    " Fleet theme highlight corrections
    " hi NormalFloat guibg=#292929
    " hi FloatBorder guifg=#292929
    " hi FloatBorder guibg=#292929
    " hi CursorLineNr guifg=#ffffff
    " hi CursorLineFold guibg=#292929
    " hi DiagnosticWarn guibg=none
    " hi DiagnosticError guibg=none
]])
