local common = require("lsp")

---@type vim.lsp.Config
return {
	cmd = { "vscode-json-language-server", "--stdio" },
	filetypes = { "json", "jsonc" },
	root_markers = { ".git" },
	capabilities = common.capabilities,
	on_attach = common.common_on_attach,
}
