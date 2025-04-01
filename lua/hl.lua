vim.cmd([[
    " Indentation colors
    hi IndentLine guifg=#64594f
    hi IndentLineCurrent guifg=#64594f

    " Force diagnostics to use undercurls
    hi DiagnosticUnderlineError gui=undercurl
    hi DiagnosticUnderlineHint gui=undercurl
    hi DiagnosticUnderlineInfo gui=undercurl
    hi DiagnosticUnderlineOk gui=undercurl
    hi DiagnosticUnderlineWarn gui=undercurl

    " DAP Colors
    hi DapBreakpoint guifg=#FF4C4C "bright red for normal breakpoints
    hi DapBreakpointCondition guifg=#FFB74C "orange for conditional breakpoints
    hi DapBreakpointRejected guifg=#767676 "gray for rejected/invalid breakpoints
    hi DapLogPoint guifg=#61AFEF "blue for logpoints
    hi DapStopped guifg=#61AFEF "blue for stopped threads

    " Some annoying bg colors
    hi WinBar guibg=none
    hi VertSplit guibg=none
    hi OverseerTaskBorder guibg=none

    " Cursor color
    hi Cursor guifg=bg guibg=#FFFFFF
    set guicursor=n-v-c-sm:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor

    " Gruvbox specific overrides
    hi link DiagnosticSignWarn GruvboxYellow
    hi link DiagnosticSignError GruvboxRed
    hi link DiagnosticSignOk GruvboxGreen
    hi link DiagnosticSignHint GruvboxAqua
]])
