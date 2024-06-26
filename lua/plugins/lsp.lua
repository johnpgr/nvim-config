return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPost" },
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "folke/neodev.nvim",
        },
        config = function()
            require("neodev").setup()
            require("mason").setup {}

            local on_attach = function()
                local map = function(keys, func)
                    vim.keymap.set({ "n", "v" }, keys, func, { noremap = true, silent = true })
                end

                map("R", "<cmd>LspRestart<cr>")
                map("<leader>ls", vim.lsp.buf.signature_help)
                map("<leader>lr", vim.lsp.buf.rename)
                map("<leader>la", vim.lsp.buf.code_action)
                map("<leader>lf", function() require("conform").format { async = true, lsp_fallback = true } end)
                map("<leader>wa", vim.lsp.buf.add_workspace_folder)
                map("<leader>wr", vim.lsp.buf.remove_workspace_folder)
                map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols)
            end

            local servers = {
                gopls = {},
                pyright = {},
                rust_analyzer = {},
                v_analyzer = { filetypes = { "vlang", "vsh" } },
                tailwindcss = {},
                prismals = {},
                sqlls = {
                    filetypes = { "sql", "mysql" },
                    cmd = { "sql-language-server", "up", "--method", "stdio" },
                    root_dir = function() return vim.loop.cwd() end,
                },
                html = { filetypes = { "html", "twig", "hbs" } },
                jsonls = {},
                lua_ls = {
                    cmd = { "lua-language-server --silent" },
                    Lua = {
                        workspace = { checkThirdParty = false },
                        telemetry = { enable = false },
                    },
                },
            }

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

            local mason_lspconfig = require "mason-lspconfig"
            mason_lspconfig.setup {
                ensure_installed = vim.tbl_keys(servers),
            }

            mason_lspconfig.setup_handlers {
                function(server_name)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities,
                        on_attach = on_attach,
                        settings = servers[server_name],
                        filetypes = (servers[server_name] or {}).filetypes,
                        -- handlers = handlers,
                    }
                end,
            }

            vim.filetype.add {
                extension = {
                    v = "vlang",
                    vsh = "vlang",
                },
            }

            vim.diagnostic.config {}
        end,
    },
    {
        "pmizio/typescript-tools.nvim",
        ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
        keys = {
            { "<leader>li", "<Cmd>TSToolsAddMissingImports<CR>", desc = "add missing imports" },
            { "<leader>lx", "<Cmd>TSToolsRemoveUnusedImports<CR>", desc = "remove unused missing imports" },
        },
        opts = {
            -- handlers = handlers,
            settings = {
                tsserver_file_preferences = {
                    includeInlayParameterNameHints = "literal",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = false,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                },
            },
        },
    },
    {
        "luckasRanarison/tailwind-tools.nvim",
        opts = {
            conceal = {
                enabled = true,
            },
        },
    },
}
