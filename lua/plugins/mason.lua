return {
	"williamboman/mason.nvim",
	dependencies = {
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		-- Setup Mason
		require("mason").setup()

		-- Setup Mason tool installer
		require("mason-tool-installer").setup({
			ensure_installed = {
				"stylua",
				"ktlint",
				"prettierd",
			},
		})

		-- Setup LSP keymaps
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("lsp-attach-group", { clear = true }),
			callback = function(event)
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
					require("utils").keymap("<leader>li", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
					end, "LSP: Inlay hints toggle")
				end
			end,
		})
	end,
}
