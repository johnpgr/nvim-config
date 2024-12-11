local util = require("utils")
local keymap = util.keymap

local JS_TS_FORMATTERS = { "prettierd", "prettier", "deno_fmt" }

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
                javascript = JS_TS_FORMATTERS,
                javascriptreact = JS_TS_FORMATTERS,
                typescript = JS_TS_FORMATTERS,
                typescriptreact = JS_TS_FORMATTERS,
                zig = { "zigfmt" },
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPost" },
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            {
                "folke/lazydev.nvim",
                ft = "lua",
                opts = {},
            },
        },
        config = function()
            local root_pattern = require("lspconfig.util").root_pattern
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("lsp-attach-group", { clear = true }),
                callback = function(event)
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                        keymap("<leader>lh", function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
                        end, "LSP: Inlay hints toggle")
                    end
                end,
            })
            local servers = {
                tailwindcss = {
                    filetypes = { "html", "typescriptreact", "javascriptreact", "css" },
                    root_dir = root_pattern(
                        "tailwind.config.js",
                        "tailwind.config.ts",
                        "tailwind.config.mjs",
                        "tailwind.config.cjs",
                        "postcss.config.js",
                        "postcss.config.ts",
                        "postcss.config.mjs",
                        "postcss.config.cjs"
                    ),
                },
                denols = {
                    root_dir = root_pattern("deno.json", "deno.jsonc"),
                    on_attach = function(client, bufnr)
                        print("denols on_attach")
                        require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
                    end,
                },
                eslint = {
                    on_attach = function(client, bufnr)
                        require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
                    end,
                },
                gopls = {
                    on_attach = function(client, bufnr)
                        require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
                    end,
                },
                pyright = {
                    on_attach = function(client, bufnr)
                        require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
                    end,
                },
                rust_analyzer = {
                    on_attach = function(client, bufnr)
                        require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
                    end,
                },
                prismals = {},
                sqlls = {
                    filetypes = { "sql", "mysql" },
                    cmd = { "sql-language-server", "up", "--method", "stdio" },
                },
                kotlin_language_server = {
                    on_attach = function(client, bufnr)
                        require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
                    end,
                },
                html = {
                    filetypes = { "html" },
                },
                htmx = {
                    filetypes = { "html" },
                },
                jsonls = {},
                lua_ls = {
                    on_attach = function(client, bufnr)
                        require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
                    end,
                    settings = {
                        Lua = {
                            completion = {
                                callSnippet = "Replace",
                            },
                            workspace = { checkThirdParty = false },
                            telemetry = { enable = false },
                            diagnostics = { disable = { "missing-fields" } },
                        },
                    },
                },
                zls = {
                    on_attach = function(client, bufnr)
                        require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
                    end,
                },
                clangd = {
                    on_attach = function(client, bufnr)
                        require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
                    end,
                },
            }

            local tools = {
                stylua = {},
                ktlint = {},
            }

            require("mason").setup()
            local ensure_installed = vim.tbl_keys(servers or {})
            local ensure_installed_tools = vim.tbl_keys(tools or {})
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
            require("mason-lspconfig").setup({
                ensure_installed = ensure_installed,
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                        require("lspconfig")[server_name].setup(server)
                    end,
                },
            })
            require("mason-tool-installer").setup({ ensure_installed = ensure_installed_tools })
        end,
    },
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
        keys = {
            { "<leader>li", "<Cmd>TSToolsAddMissingImports<cr>", desc = "LSP: Add missing imports" },
            { "<leader>lx", "<Cmd>TSToolsRemoveUnusedImports<cr>", desc = "LSP: Remove unused missing imports" },
        },
        config = function()
            local root_pattern = require("lspconfig.util").root_pattern
            require("typescript-tools").setup({
                root_dir = root_pattern("package.json", "tsconfig.json", "jsconfig.json"),
                single_file_support = false,
                on_attach = function(client, bufnr)
                    require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
                end,
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
                        enable = false,
                        filetypes = { "javascriptreact", "typescriptreact" },
                    },
                },
            })
        end,
    },
    {
        "dmmulroy/tsc.nvim",
        cmd = "TSC",
        ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        opts = {
            enable_progress_notifications = true,
            auto_open_qflist = true,
        },
    },
}
