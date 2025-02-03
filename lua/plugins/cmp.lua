return {
    {
        "iguanacucumber/magazine.nvim",
        name = "nvim-cmp",
        event = "VeryLazy",
        dependencies = {
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "onsails/lspkind.nvim",
            {
                "L3MON4D3/LuaSnip",
                build = (function()
                    if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
                        return
                    end
                    return "make install_jsregexp"
                end)(),
                dependencies = {
                    {
                        "rafamadriz/friendly-snippets",
                        config = function()
                            require("luasnip.loaders.from_vscode").lazy_load()
                        end,
                    },
                },
            },
            {
                "xzbdmw/colorful-menu.nvim",
                config = function()
                    require("colorful-menu").setup({})
                end,
            },
        },
        config = function()
            local utils = require("utils")
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            luasnip.config.setup({})
            local mappings = cmp.mapping.preset.insert({
                -- Select the [n]ext item
                ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
                -- Select the [p]revious item
                ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
                -- Scroll the documentation window [b]ack / [f]orward
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                -- Accept ([y]es) the completion.
                --  This will auto-import if your LSP supports it.
                --  This will expand snippets if the LSP sent a snippet.
                ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
                ["<Tab>"] = cmp.mapping(function(fallback)
                    local copilot_suggestions = require("copilot.suggestion")

                    if cmp.visible() then
                        cmp.confirm({ select = true })
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
                    local copilot_suggestions = require("copilot.suggestion")

                    if copilot_suggestions.is_visible() then
                        copilot_suggestions.accept()
                    elseif cmp.visible() then
                        cmp.confirm({ select = true })
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                -- Manually trigger a completion from nvim-cmp.
                --  Generally you don't need this, because nvim-cmp will display
                --  completions whenever it has completion options available.
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
                -- Think of <c-l> as moving to the right of your snippet expansion.
                --  So if you have a snippet that's like:
                --  function $name($args)
                --    $body
                --  end
                --
                -- <c-l> will move you to the right of each of the expansion locations.
                -- <c-h> is similar, except moving you backwards.
                ["<C-l>"] = cmp.mapping(function()
                    if luasnip.expand_or_locally_jumpable() then
                        luasnip.expand_or_jump()
                    end
                end, { "i", "s" }),
                ["<C-h>"] = cmp.mapping(function()
                    if luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    end
                end, { "i", "s" }),

                -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
                --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
            })

            cmp.setup.cmdline("/", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                },
            })
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline({
                    ["<Tab>"] = {
                        c = cmp.mapping.confirm({ select = true }),
                    },
                }),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    {
                        name = "cmdline",
                        option = {
                            ignore_cmds = { "Man", "!", "terminal", "term" },
                        },
                    },
                }),
            })

            local formatting = {
                fields = {
                    "abbr",
                    "menu",
                },
                expandable_indicator = true,
                format = function(entry, vim_item)
                    local lspkind_opts = {
                        preset = "codicons",
                        mode = "symbol",
                        maxwidth = 50,
                        ellipsis_char = "...",
                    }

                    local kind = require("lspkind").cmp_format(lspkind_opts)(entry, vim.deepcopy(vim_item))
                    local highlights_info = require("colorful-menu").cmp_highlights(entry)

                    if highlights_info ~= nil and highlights_info.text ~= nil then
                        vim_item.abbr_hl_group = highlights_info.highlights
                        vim_item.abbr = highlights_info.text
                    end

                    local strings = vim.split(kind.kind, "%s", { trimempty = true })
                    vim_item.kind = strings[1] or ""
                    vim_item.menu = ""

                    return vim_item
                end,
            }


            if utils.nerd_icons then
                formatting.fields = {
                    "kind",
                    "abbr",
                    "menu",
                }
            end

            cmp.setup({
                formatting = formatting,
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = mappings,
                completion = { completeopt = "menu,menuone,popup,noinsert" },
                sources = {
                    {
                        name = "lazydev",
                        group_index = 0,
                    },
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "path" },
                },
            })

            local function toggle_cmp()
                if cmp.get_config().completion.autocomplete == false then
                    cmp.setup({
                        completion = {
                            autocomplete = { "InsertEnter", "TextChanged" },
                        },
                    })
                    print("Autocompletion enabled")
                else
                    cmp.setup({
                        completion = {
                            autocomplete = false,
                        },
                    })
                    print("Autocompletion disabled")
                end
            end

            utils.keymap("<leader>ta", toggle_cmp, "Toggle Autocomplete")
        end,
    },
}
