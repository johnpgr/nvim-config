local common = require("lsp")

---@type vim.lsp.Config
return {
	cmd = { "zls" },
	filetypes = { "zig", "zir" },
	root_markers = { "zls.json", "build.zig", ".git" },
	workspace_required = false,
	capabilities = common.capabilities,
	on_attach = common.common_on_attach,
}
