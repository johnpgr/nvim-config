local util = require("utils")
local keymap = util.keymap

vim.g.zig_fmt_autosave = 0

local formatters = { "prettierd", "prettier", "deno_fmt" }

local function common_on_attach(client, bufnr)
	require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
end

return {
	{
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
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
			local servers = {
				vtsls = {},
				tailwindcss = {
					filetypes = { "html", "htmldjango", "typescriptreact", "javascriptreact", "css", "astro" },
				},
				denols = {
					root_dir = require("lspconfig.util").root_pattern({
						"deno.json",
						"deno.jsonc",
					}),
				},
				eslint = {},
				gopls = {},
				pyright = {},
				rust_analyzer = {},
				prismals = {},
				sqlls = {
					filetypes = { "sql", "mysql" },
					cmd = { "sql-language-server", "up", "--method", "stdio" },
				},
				kotlin_language_server = {},
				html = {
					filetypes = { "html", "htmldjango" },
				},
				htmx = {
					filetypes = { "html", "htmldjango" },
				},
				jsonls = {},
				-- lua_ls = {
				--     settings = {
				--         Lua = {
				--             completion = {
				--                 callSnippet = "Replace",
				--             },
				--             workspace = { checkThirdParty = false },
				--             telemetry = { enable = false },
				--             diagnostics = { disable = { "missing-fields" } },
				--         },
				--     },
				-- },
				zls = {},
				clangd = {},
			}

			local tools = {
				stylua = {},
				ktlint = {},
				prettierd = {},
			}

			local ensure_installed = vim.tbl_keys(servers or {})
			local ensure_installed_tools = vim.tbl_keys(tools or {})

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach-group", { clear = true }),
				callback = function(event)
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						keymap("<leader>li", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "LSP: Inlay hints toggle")
					end
				end,
			})

			require("mason").setup()
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed_tools })

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			require("mason-lspconfig").setup({
				ensure_installed = ensure_installed,
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						-- Add common on_attach to servers that don't have specific on_attach
						if not server.on_attach then
							server.on_attach = common_on_attach
						end
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"nvim-flutter/flutter-tools.nvim",
        ft = "dart",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("flutter-tools").setup({
				debugger = {
					enabled = false,
					register_configurations = function(_)
						require("dap").adapters.dart = {
							type = "executable",
							command = vim.fn.stdpath("data") .. "/mason/bin/dart-debug-adapter",
							args = { "flutter" },
						}
						require("dap").configurations.dart = {
							type = "dart",
							request = "launch",
							name = "Launch flutter",
							dartSdkPath = ".local/flutter/bin/cache/dart-sdk/",
							flutterSdkPath = ".local/flutter",
							program = "${workspaceFolder}/lib/main.dart",
							cwd = "${workspaceFolder}",
						}
					end,
				},
				dev_log = {
					open_cmd = "tabedit",
				},
			})
		end,
	},
}
