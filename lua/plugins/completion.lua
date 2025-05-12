return {
	{ "xzbdmw/colorful-menu.nvim", config = function() end },
	{
		"saghen/blink.cmp",
		-- optional: provides snippets for the snippet source
		dependencies = {
			"L3MON4D3/LuaSnip",
			version = "v2.*",
			build = "make install_jsregexp",
			dependencies = "rafamadriz/friendly-snippets",
		},

		-- use a release tag to download pre-built binaries
		version = "1.*",
		-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',
		config = function()
			local menu = require("blink.cmp.completion.windows.menu")

			local function toggle_menu(cmp)
				if not menu.win:is_open() then
					cmp.show()
				else
					cmp.hide()
				end
			end

			local function has_copilot_suggestion()
				local copilot = require("copilot.suggestion")
				return copilot.is_visible()
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
				-- If completion menu is visible, accept selected item
				if menu.win:is_open() then
					cmp.select_and_accept()
				-- Accept Copilot suggestion
				elseif has_copilot_suggestion() then
					require("copilot.suggestion").accept()
				elseif has_words_before() then
					cmp.insert_next()
				-- Fallback to default behavior
				else
					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
				end
			end

			require("blink.cmp").setup({
				-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
				-- 'super-tab' for mappings similar to vscode (tab to accept)
				-- 'enter' for enter to accept
				-- 'none' for no mappings
				--
				-- All presets have the following mappings:
				-- C-space: Open menu or open docs if already open
				-- C-n/C-p or Up/Down: Select next/previous item
				-- C-e: Hide menu
				-- C-k: Toggle signature help (if signature.enabled = true)
				--
				-- See :h blink-cmp-config-keymap for defining your own keymap
				keymap = {
					preset = "super-tab",
					["<Tab>"] = { handle_tab },
					["<C-m>"] = { toggle_menu },
					["<C-Space>"] = { toggle_menu },
					["<CR>"] = { "accept", "fallback" },
					["<C-y>"] = { "select_and_accept" },
				},

				appearance = {
					-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
					-- Adjusts spacing to ensure icons are aligned
					nerd_font_variant = "normal",
				},

				-- (Default) Only show the documentation popup when manually triggered
				completion = {
					menu = {
						draw = {
							-- We don't need label_description now because label and label_description are already
							-- combined together in label by colorful-menu.nvim.
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
						},
					},
					documentation = { auto_show = true },
				},

				snippets = {
					preset = "luasnip",
				},
				cmdline = {
					keymap = {
						preset = "cmdline",
						["<Tab>"] = { handle_tab },
					},
				},
				-- Default list of enabled providers defined so that you can extend it
				-- elsewhere in your config, without redefining it, due to `opts_extend`
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
							-- ignores cmdline completions when executing shell commands
							enabled = function()
								local cmdline = vim.fn.getcmdline()
								return vim.fn.getcmdtype() ~= ":"
									or not (cmdline:match("^[%%0-9,'<>%-]*!") or cmdline:match("^%s*term%s*"))
							end,
						},
					},
				},

				-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
				-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
				-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
				--
				-- See the fuzzy documentation for more information
				fuzzy = { implementation = "prefer_rust_with_warning" },
			})

			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},
}
