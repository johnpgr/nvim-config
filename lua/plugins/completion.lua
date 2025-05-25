return {
	"saghen/blink.cmp",
    version = "1.*",
	-- optional: provides snippets for the snippet source
	dependencies = {
		{ "xzbdmw/colorful-menu.nvim", enabled = vim.g.nerdicons_enabled, opts = {} },
		{
			"L3MON4D3/LuaSnip",
			version = "v2.*",
			build = "make install_jsregexp",
			dependencies = "rafamadriz/friendly-snippets",
		},
	},

	-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
	-- build = 'cargo build --release',
	-- If you use nix, you can build from source using latest nightly rust with:
	-- build = 'nix run .#build-plugin',
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

		local function has_words_before()
			local col = vim.api.nvim_win_get_cursor(0)[2]
			if col == 0 then
				return false
			end
			local line = vim.api.nvim_get_current_line()
			return line:sub(col, col):match("%s") == nil
		end

		local function handle_tab(cmp)
			if blink.is_visible() then
				cmp.select_and_accept()
			elseif copilot.is_visible() then
				copilot.accept()
			elseif has_words_before() then
				cmp.insert_next()
			else
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
			end
		end

		local draw = vim.g.nerdicons_enable
				and {
					columns = { { "kind_icon" }, { "label" } },
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

			cmdline = {
				completion = {
					menu = {
						auto_show = true,
						draw = {
							columns = {
								{ "label" },
							},
						},
					},
				},
				keymap = {
					preset = "cmdline",
					["<Tab>"] = { handle_tab },
				},
			},
			sources = {
				default = { "lazydev", "lsp", "path", "snippets", "buffer" },
				per_filetype = {
					sql = { "snippets", "dadbod", "buffer" },
					["copilot-chat"] = { "snippets", "path" },
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
								or not (cmdline:match("^[%%0-9,'<>%-]*!") or cmdline:match("^%s*term%s*"))
						end,
					},
				},
			},

			fuzzy = { implementation = "prefer_rust_with_warning" },
		})

		require("luasnip.loaders.from_vscode").lazy_load()
	end,
}
