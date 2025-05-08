local common = require("lsp")

---@type vim.lsp.Config
return {
	cmd = { "vscode-html-language-server", "--stdio" },
	filetypes = { "html", "htmldjango", "templ" },
	root_markers = { "package.json", ".git" },
	settings = {},
	init_options = {
		provideFormatter = true,
		embeddedLanguages = { css = true, javascript = true },
		configurationSection = { "html", "css", "javascript" },
	},
	capabilities = common.capabilities,
	on_attach = common.common_on_attach,
}
