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
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")
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

            cmp.setup({
                -- formatting = {
                --     expandable_indicator = true,
                --     fields = {
                --         "kind",
                --         "abbr",
                --         "menu",
                --     },
                --     format = lspkind.cmp_format({
                --         preset = "codicons",
                --         mode = "symbol",
                --         maxwidth = 50,
                --         ellipsis_char = "...",
                --     }),
                -- },
                formatting = {
                    fields = { "kind", "abbr", "menu" },
                    format = function(entry, vim_item)
                        local completion_item = entry:get_completion_item()
                        local highlights_info = require("colorful-menu").highlights(completion_item, vim.bo.filetype)

                        -- error, such as missing parser, fallback to use raw label.
                        if highlights_info == nil then
                            vim_item.abbr = completion_item.label
                        else
                            vim_item.abbr_hl_group = highlights_info.highlights
                            vim_item.abbr = highlights_info.text
                        end

                        local kind = require("lspkind").cmp_format({
                            preset = "codicons",
                            mode = "symbol_text",
                        })(entry, vim_item)
                        local strings = vim.split(kind.kind, "%s", { trimempty = true })
                        vim_item.kind = strings[1] or ""
                        vim_item.menu = ""

                        return vim_item
                    end,
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = mappings,
                completion = { completeopt = "menu,menuone,popup,noinsert" },
                -- For an understanding of why these mappings were
                -- chosen, you will need to read `:help ins-completion`
                -- No, but seriously. Please read `:help ins-completion`, it is really good!
                sources = {
                    {
                        name = "lazydev",
                        -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
                        group_index = 0,
                    },
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "path" },
                },
            })
        end,
    },
    {
        "xzbdmw/colorful-menu.nvim",
        config = function()
            -- You don't need to set these options.
            require("colorful-menu").setup({
                ft = {
                    lua = {
                        -- Maybe you want to dim arguments a bit.
                        auguments_hl = "@comment",
                    },
                    go = {
                        -- When true, label for field and variable will format like "foo: Foo"
                        -- instead of go's original syntax "foo Foo".
                        add_colon_before_type = false,
                    },
                    typescript = {
                        -- Add more filetype when needed, these three taken from lspconfig are default value.
                        enabled = { "typescript", "typescriptreact", "typescript.tsx" },
                        -- Or "vtsls", their information is different, so we
                        -- need to know in advance.
                        ls = "typescript-language-server",
                        extra_info_hl = "@comment",
                    },
                    rust = {
                        -- Such as (as Iterator), (use std::io).
                        extra_info_hl = "@comment",
                    },
                    c = {
                        -- Such as "From <stdio.h>"
                        extra_info_hl = "@comment",
                    },

                    -- If true, try to highlight "not supported" languages.
                    fallback = true,
                },
                -- If the built-in logic fails to find a suitable highlight group,
                -- this highlight is applied to the label.
                fallback_highlight = "@variable",
                -- If provided, the plugin truncates the final displayed text to
                -- this width (measured in display cells). Any highlights that extend
                -- beyond the truncation point are ignored. Default 60.
                max_width = 60,
            })
        end,
    },
}
