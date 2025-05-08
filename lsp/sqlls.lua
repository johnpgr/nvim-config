local common = require("lsp")

---@type vim.lsp.Config
return {
	cmd = { "sql-language-server", "up", "--method", "stdio" },
	filetypes = { "sql", "mysql" },
	root_markers = { ".sqllsrc.json" },
    settings = {},
	capabilities = common.capabilities,
	on_attach = common.common_on_attach,
}
