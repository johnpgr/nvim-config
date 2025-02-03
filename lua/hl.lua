local function sethl(name, tbl)
    vim.api.nvim_set_hl(0, name, tbl)
end
sethl("DapBreakpoint", { fg = "#FF4C4C" }) -- bright red for normal breakpoints
sethl("DapBreakpointCondition", { fg = "#FFB74C" }) -- orange for conditional breakpoints
sethl("DapBreakpointRejected", { fg = "#767676" }) -- gray for rejected/invalid breakpoints
sethl("DapLogPoint", { fg = "#61AFEF" }) -- blue for logpoints
sethl("DapStopped", { fg = "#61AFEF" }) -- blue for stopped threads

vim.cmd([[
    hi link WinBar Normal
    hi link NormalFloat FloatBorder
    hi link NeogitWinSeparator WinSeparator
    " hi FloatBorder guibg=none
    " hi WinSeparator guibg=none
    " hi VertSplit guibg=none
    " hi Normal guibg=none
    hi SignColumn guibg=none
    hi FoldColumn guibg=none
    hi GitGutterAdd guibg=none
    hi GitGutterChange guibg=none
    hi GitGutterDelete guibg=none
    hi GitGutterChangeDelete guibg=none
    " hi TelescopePromptPrefix guibg=none
    " hi TelescopePromptNormal guibg=#000000 
    " hi TelescopePromptBorder guibg=#000000 guifg=#000000
    " hi Comment guifg=#595959
    " hi TSComment guifg=#595959
    " Gruvbox theme highlight corrections
    " hi Operator guibg=none
    " hi GruvboxGreenSign guibg=none
    " hi GruvboxAquaSign guibg=none
    " hi GruvboxRedSign guibg=none
    " hi GruvboxRed guifg=#fb6150
    " Fleet theme highlight corrections
    " hi NormalFloat guibg=#292929
    " hi FloatBorder guifg=#292929
    " hi FloatBorder guibg=#292929
    " hi CursorLineNr guifg=#ffffff
    " hi CursorLineFold guibg=#292929
    " hi DiagnosticWarn guibg=none
    " hi DiagnosticError guibg=none
    hi Special gui=none cterm=none
    hi @comment gui=none cterm=none
    hi Comment gui=none cterm=none
]])

--
-- local fleet = require("fleet-theme.palette").palette
--
-- local FleetTelescope = {
--     TelescopeMatching = { fg = fleet.cyan },
--     TelescopeSelection = { fg = fleet.lightest, bg = fleet.darker, bold = true },
--     TelescopePromptPrefix = { bg = fleet.surface0 },
--     TelescopePromptNormal = { bg = fleet.surface0 },
--     TelescopePromptBorder = { bg = fleet.background, fg = fleet.background },
--     TelescopePromptTitle = { bg = fleet.pink, fg = fleet.darker },
--     TelescopeResultsNormal = { bg = fleet.background },
--     TelescopePreviewNormal = { bg = fleet.background },
--     TelescopeResultsBorder = { bg = fleet.background, fg = fleet.background },
--     TelescopePreviewBorder = { bg = fleet.background, fg = fleet.background },
--     TelescopeResultsTitle = { fg = fleet.purple },
--     TelescopePreviewTitle = { bg = fleet.green, fg = fleet.darker },
-- }
--
-- for hl, col in pairs(FleetTelescope) do
--     sethl(hl, col)
-- end
