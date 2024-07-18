return {
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lsp",
            "rafamadriz/friendly-snippets",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            -- "hrsh7th/cmp-nvim-lsp-signature-help",
        },
        config = function()
            local cmp = require "cmp"
            local luasnip = require "luasnip"
            local lspkind = require "lspkind"

            require("luasnip.loaders.from_vscode").lazy_load()
            luasnip.config.setup {}

            cmp.setup.cmdline("/", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                },
            })

            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    {
                        name = "cmdline",
                        option = {
                            ignore_cmds = { "Man", "!" },
                        },
                    },
                }),
            })

            cmp.setup {
                -- window = {
                --     completion = cmp.config.window.bordered {
                --         scrollbar = true,
                --     },
                --     documentation = cmp.config.window.bordered {},
                -- },
                formatting = {
                    expandable_indicator = true,
                    fields = {
                        "kind",
                        "abbr",
                        "menu",
                    },
                    format = lspkind.cmp_format {
                        preset = "codicons",
                        mode = "symbol",
                        maxwidth = 50,
                        ellipsis_char = "...",
                    },
                },
                snippet = {
                    expand = function(args) luasnip.lsp_expand(args.body) end,
                },
                mapping = cmp.mapping.preset.insert {
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping(function(_)
                        if cmp.visible() then
                            cmp.close()
                        else
                            cmp.complete()
                        end
                    end, {
                        "i",
                        "s",
                    }),
                    ["<CR>"] = cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    },
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        local copilot_suggestions = require "copilot.suggestion"

                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif copilot_suggestions.is_visible() then
                            copilot_suggestions.accept()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, {
                        "i",
                        "s",
                    }),

                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                },
                sources = {
                    { name = "nvim_lsp" },
                    -- { name = "nvim_lsp_signature_help" },
                    { name = "luasnip", keyword_length = 2 },
                    { name = "buffer",  keyword_length = 3 },
                    { name = "path" },
                },
            }
        end,
    },
    {
        "zbirenbaum/copilot-cmp",
        event = "InsertEnter",
        dependencies = { "zbirenbaum/copilot.lua" },
        config = function()
            require("copilot").setup {
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    debounce = 50,
                },
                filetypes = {
                    yaml = true,
                    markdown = true,
                    help = false,
                    gitcommit = false,
                    gitrebase = false,
                    hgcommit = false,
                    svn = false,
                    cvs = false,
                    ["."] = false,
                },
                copilot_node_command = "node",
                server_opts_overrides = {},
            }
            require("copilot_cmp").setup()
        end,
    },
}
