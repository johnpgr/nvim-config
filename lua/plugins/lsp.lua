return {
    {
        "stevearc/conform.nvim",
        lazy = false,
        opts = {
            notify_on_error = false,
            format_on_save = function(bufnr)
                local disable_filetypes = { c = true, cpp = true }
                local format_args = {
                    timeout_ms = 500,
                    lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
                }
                return format_args
            end,
            formatters_by_ft = {
                lua = { "stylua" },
                javascript = { { "prettierd", "prettier" } },
                javascriptreact = { { "prettierd", "prettier" } },
                typescript = { { "prettierd", "prettier" } },
                typescriptreact = { { "prettierd", "prettier" } },
                zig = { { "zig" } },
            },
        },
    },
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
                ---@param keys string
                ---@param func function | string
                ---@param desc string
                local map = function(keys, func, desc)
                    vim.keymap.set({ "n", "v" }, keys, func, { noremap = true, silent = true, desc = desc })
                end

                map("R", "<cmd>LspRestart<cr>", "LSP: Restart language server")
                map("<leader>ls", vim.lsp.buf.signature_help, "LSP: Show Signature help")
                map("<leader>lr", vim.lsp.buf.rename, "LSP: Rename variable")
                map("<leader>la", vim.lsp.buf.code_action, "LSP: Show Code actions")
                map("<leader>lf", function() require("conform").format { async = true, lsp_fallback = true } end,
                    "LSP: Format buffer")
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

            local lspconfig = require "lspconfig"
            lspconfig.mojo.setup {}
            lspconfig.htmx.setup {}

            vim.diagnostic.config {}
        end,
    },
    {
        "pmizio/typescript-tools.nvim",
        ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
        keys = {
            { "<leader>li", "<Cmd>TSToolsAddMissingImports<cr>",    desc = "Add missing imports" },
            { "<leader>lx", "<Cmd>TSToolsRemoveUnusedImports<cr>",  desc = "Remove unused missing imports" },
            { "<leader>gd", "<cmd>TSToolsGoToSourceDefinition<cr>", desc = "Goto source definition (typescript bundled)" }
        },
        opts = {
            -- handlers = handlers,
            settings = {
                tsserver_file_preferences = {
                    includeInlayParameterNameHints = "all",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                    includeInlayVariableTypeHintsWhenTypeMatchesName = true,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                },
                jsx_close_tag = {
                    enable = true,
                    filetypes = { "javascriptreact", "typescriptreact" },
                }
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
