local formatters = { "prettierd", "prettier", "deno_fmt" }

return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		notify_on_error = false,
		format_after_save = false,
		formatters_by_ft = {
			lua = { "stylua" },
			javascript = formatters,
			javascriptreact = formatters,
			typescript = formatters,
			typescriptreact = formatters,
			zig = { "zigfmt" },
			sql = { "pg_format" },
		},
	},
}
