local function hl(name, opts)
	local hl_group = vim.api.nvim_create_namespace(name)
	vim.api.nvim_set_hl(0, name, opts)
	return hl_group
end

-- Force diagnostics to use undercurls
hl("DiagnosticUnderlineError", { undercurl = true })
hl("DiagnosticUnderlineHint", { undercurl = true })
hl("DiagnosticUnderlineInfo", { undercurl = true })
hl("DiagnosticUnderlineOk", { undercurl = true })
hl("DiagnosticUnderlineWarn", { undercurl = true })
hl("DapBreakpoint", { fg = "#FF4C4C" }) -- bright red for normal breakpoints
hl("DapBreakpointCondition", { fg = "#FFB74C" }) -- orange for conditional breakpoints
hl("DapBreakpointRejected", { fg = "#767676" }) -- gray for rejected/invalid breakpoints
hl("DapLogPoint", { fg = "#61AFEF" }) -- blue for logpoints
hl("DapStopped", { fg = "#61AFEF" }) -- blue for stopped threads
hl("WinBar", { bg = "none" })
hl("VertSplit", { bg = "none" })
hl("OverseerTaskBorder", { bg = "none" })
if vim.g.colors_name:match("base16%-.*%-metal") then
	hl("TelescopePromptNormal", { bg = "#000000" })
	hl("TelescopePromptBorder", { bg = "#000000" })
	hl("TelescopePromptPrefix", { bg = "#000000" })
end

if vim.g.colors_name:match("NeoSolarized") then
	hl("LineNr", { bg = "none" })
	hl("CursorLineNr", { bg = "#063642" })
	hl("MatchParen", { fg = "none", bg = "#005266" })
end

vim.cmd([[
    hi! link GruvboxRedSign GruvboxRed
    hi! link GruvboxGreenSign GruvboxGreen
    hi! link GruvboxYellowSign GruvboxYellow
    hi! link GruvboxBlueSign GruvboxBlue
    hi! link GruvboxAquaSign GruvboxAqua
    hi! link GruvboxPurpleSign GruvboxPurple
    hi! link LspReferenceRead MatchParen
    hi! link LspReferenceWrite MatchParen
    hi! link LspReferenceTarget MatchParen
    hi! link LspReferenceText MatchParen
]])
