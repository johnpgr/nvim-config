return {
	"saghen/blink.cmp",
	event = { "InsertEnter", "CmdlineEnter" },
	version = "1.*",
	dependencies = {
		{ "xzbdmw/colorful-menu.nvim", enabled = vim.g.nerdicons_enabled, opts = {} },
		{
			"L3MON4D3/LuaSnip",
			version = "v2.*",
			build = "make install_jsregexp",
			dependencies = "rafamadriz/friendly-snippets",
		},
	},

	config = function()
		local blink = require("blink.cmp")
		local copilot = require("copilot.suggestion")

		local function toggle_menu(cmp)
			if not blink.is_visible() then
				cmp.show()
			else
				cmp.hide()
			end
		end

		local function handle_tab(cmp)
			if blink.is_visible() then
				cmp.select_and_accept()
			elseif copilot.is_visible() then
				copilot.accept()
			else
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
			end
		end

		local draw = vim.g.nerdicons_enable
				and {
					columns = {
						{ "kind_icon", "label", gap = 1 },
						{ "kind" },
					},
					components = {
						label = {
							text = function(ctx)
								return require("colorful-menu").blink_components_text(ctx)
							end,
							highlight = function(ctx)
								return require("colorful-menu").blink_components_highlight(ctx)
							end,
						},
					},
				}
			or {
				columns = {
					{ "label" },
					{ "kind" },
				},
			}

		blink.setup({
			keymap = {
				preset = "super-tab",
				["<Tab>"] = { handle_tab },
				["<C-m>"] = { toggle_menu },
				["<C-Space>"] = { toggle_menu },
				["<CR>"] = { "accept", "fallback" },
				["<C-y>"] = { "select_and_accept" },
			},

			appearance = vim.g.nerdicons_enabled and { nerd_font_variant = "normal" } or {},

			completion = {
				menu = {
					draw = draw,
				},
				documentation = { auto_show = true },
			},

			snippets = {
				preset = "luasnip",
			},

			sources = {
				default = { "lazydev", "lsp", "path", "snippets", "buffer" },
				per_filetype = {
					sql = { "snippets", "dadbod", "buffer" },
					["copilot-chat"] = { "snippets", "buffer", "path" },
				},
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
					dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
					cmdline = {
						enabled = function()
							local cmdline = vim.fn.getcmdline()
							return vim.fn.getcmdtype() ~= ":"
								or not (
									cmdline:match("^[%%0-9,'<>%-]*!")
									or cmdline:match("^%s*term%s*")
									or cmdline:match("^%s*Compile%s*")
								)
						end,
					},
				},
			},

			fuzzy = { implementation = "prefer_rust_with_warning" },
		})

		require("luasnip.loaders.from_vscode").lazy_load()
	end,
}
