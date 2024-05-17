---@diagnostic disable: missing-fields

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    'nvim-lua/plenary.nvim',
    'tpope/vim-fugitive',
    'tpope/vim-rhubarb',
    'tpope/vim-sleuth',
    'tpope/vim-surround',
    'mg979/vim-visual-multi',
    'kdheepak/lazygit.nvim',
    'onsails/lspkind.nvim',
    'folke/trouble.nvim',
    'nvim-tree/nvim-web-devicons',
    'mbbill/undotree',
    {
        'folke/todo-comments.nvim',
        event = 'BufRead',
    },
    {
        'nvim-telescope/telescope.nvim',
        event = 'VeryLazy',
        branch = '0.1.x',
        dependencies = {
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make',
                cond = function()
                    return vim.fn.executable 'make' == 1
                end,
            },
            {
                'johmsalas/text-case.nvim',
                config = function()
                    require('textcase').setup({})
                end
            },
            { 'nvim-telescope/telescope-ui-select.nvim' },
        },
        config = function()
            require('telescope').setup({
                defaults = {
                    mappings = {
                        i = {
                            ['<C-u>'] = false,
                        },
                    },
                },
                pickers = {
                    buffers = {
                        theme = 'dropdown'
                    },
                }
            })
        end,
        init = function()
            local t = require('telescope')
            t.load_extension('fzf')
            t.load_extension('textcase')
            t.load_extension('ui-select')
        end
    },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-nvim-lsp',
            'rafamadriz/friendly-snippets',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
        },
        config = function()
            local cmp = require('cmp')
            local luasnip = require('luasnip')
            local lspkind = require('lspkind')

            require('luasnip.loaders.from_vscode').lazy_load()
            luasnip.config.setup {}

            cmp.setup.cmdline('/', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'buffer' }
                }
            })

            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources(
                    {
                        { name = 'path' }
                    },
                    {
                        {
                            name = 'cmdline',
                            option = {
                                ignore_cmds = { 'Man', '!' }
                            }
                        }
                    }
                )
            })

            cmp.setup({
                -- window = {
                -- completion = cmp.config.window.bordered {},
                -- documentation = cmp.config.window.bordered {},
                -- },
                formatting = {
                    expandable_indicator = true,
                    fields = {
                        'kind',
                        'abbr',
                        'menu'
                    },
                    format = lspkind.cmp_format({
                        preset = 'codicons',
                        mode = 'symbol',
                        maxwidth = 50,
                        ellipsis_char = '...',
                    })
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end
                },
                mapping = cmp.mapping.preset.insert {
                    ['<C-p>'] = cmp.mapping.select_prev_item(),
                    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping(function(_)
                        if cmp.visible() then
                            cmp.close()
                        else
                            cmp.complete()
                        end
                    end, {
                        'i',
                        's'
                    }),
                    ['<CR>'] = cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    },
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        local copilot_suggestions = require('copilot.suggestion')

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
                        'i',
                        's',
                    }),

                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                },
                sources = {
                    { name = 'nvim_lsp' },
                    -- { name = 'luasnip', keyword_length = 2 },
                    { name = 'buffer',  keyword_length = 3 },
                    { name = 'path' }
                },
            })
        end
    },
    {
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        build = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup({
                autotag = {
                    enable = true,
                },
                ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim', 'v' },
                auto_install = true,
                highlight = { enable = true },
                -- indent = { enable = true },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = '<c-space>',
                        node_incremental = '<c-space>',
                        scope_incremental = '<c-s>',
                        node_decremental = '<M-space>',
                    },
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ['a='] = { query = '@assignment.outer', desc = 'Select outer part of an assignment' },
                            ['i='] = { query = '@assignment.inner', desc = 'Select inner part of an assignment' },
                            ['l='] = { query = '@assignment.lhs', desc = 'Select left hand side of an assignment' },
                            ['r='] = { query = '@assignment.rhs', desc = 'Select right hand side of an assignment' },
                            ['a:'] = { query = '@property.outer', desc = 'Select outer part of an object property' },
                            ['i:'] = { query = '@property.inner', desc = 'Select inner part of an object property' },
                            ['l:'] = { query = '@property.lhs', desc = 'Select left part of an object property' },
                            ['r:'] = { query = '@property.rhs', desc = 'Select right part of an object property' },
                            ['aa'] = { query = '@parameter.outer', desc = 'Select outer part of a parameter/argument' },
                            ['ia'] = { query = '@parameter.inner', desc = 'Select inner part of a parameter/argument' },
                            ['ai'] = { query = '@conditional.outer', desc = 'Select outer part of a conditional' },
                            ['ii'] = { query = '@conditional.inner', desc = 'Select inner part of a conditional' },
                            ['al'] = { query = '@loop.outer', desc = 'Select outer part of a loop' },
                            ['il'] = { query = '@loop.inner', desc = 'Select inner part of a loop' },
                            ['af'] = { query = '@function.outer', desc = 'Select outer part of a method/function definition' },
                            ['if'] = { query = '@function.inner', desc = 'Select inner part of a method/function definition' },
                            ['ac'] = { query = '@class.outer', desc = 'Select outer part of a class' },
                            ['ic'] = { query = '@class.inner', desc = 'Select inner part of a class' },
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = {
                            [']f'] = '@function.outer',
                            [']c'] = '@class.outer',
                        },
                        goto_next_end = {
                            [']F'] = '@function.outer',
                            [']C'] = '@class.outer',
                        },
                        goto_previous_start = {
                            ['[f'] = '@function.outer',
                            ['[c'] = '@class.outer',
                        },
                        goto_previous_end = {
                            ['[F'] = '@function.outer',
                            ['[C'] = '@class.outer',
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ['<leader>sn'] = '@parameter.inner',
                        },
                        swap_previous = {
                            ['<leader>sp'] = '@parameter.inner',
                        },
                    },
                },
            })
        end
    },
    {
        'nvim-pack/nvim-spectre',
        lazy = true,
        cmd = { 'Spectre' },
        config = function()
            require('spectre').setup({
                highlight = {
                    search = 'SpectreSearch',
                    replace = 'SpectreReplace',
                },
                mapping = {
                    ['send_to_qf'] = {
                        map = '<C-q>',
                        cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
                        desc = 'send all items to quickfix',
                    },
                },
            })
        end,
    },
    {
        'iamcco/markdown-preview.nvim',
        ft = 'markdown',
        build = function()
            vim.fn['mkdp#util#install']()
        end,
        cmd = {
            'MarkdownPreview',
            'MarkdownPreviewStop',
            'MarkdownPreviewToggle',
        }
    },
    {
        'nvim-lualine/lualine.nvim',
        config = function()
            local path_utils = require('utils.file-path')
            local harpoon = require('harpoon')

            local function string_includes(str, substr)
                return string.find(str, substr, 1, true) ~= nil
            end

            local function ignored_filetypes(current_filetype)
                local ignore = {
                    'oil',
                    'toggleterm',
                    'alpha',
                    'harpoon',
                    'TelescopePrompt',
                }

                if vim.tbl_contains(ignore, current_filetype) then
                    return true
                end

                return false
            end

            local function harpoon_component()
                if ignored_filetypes(vim.bo.filetype) then
                    return ''
                end

                local total_marks = harpoon:list():length()
                if total_marks == 0 then
                    return ''
                end

                local current_mark_name = path_utils.current_file_path_in_cwd()
                local current_mark_index = -1

                for index, mark in ipairs(harpoon:list().items) do
                    if string_includes(current_mark_name, mark.value) then
                        current_mark_index = index
                    end
                end

                if (current_mark_index == -1) then
                    return string.format('󱝴 %s/%d', '-', total_marks)
                end

                return string.format('󱝴 %d/%d', current_mark_index, total_marks)
            end

            local function filename()
                if ignored_filetypes(vim.bo.filetype) then
                    return ''
                end

                return path_utils.relative_file_path()
            end

            local function current_indentation()
                if ignored_filetypes(vim.bo.filetype) then
                    return ''
                end

                local current_indent = vim.bo.expandtab and 'spaces' or 'tab size'

                local indent_size = -1

                if current_indent == 'spaces' then
                    indent_size = vim.bo.shiftwidth
                else
                    indent_size = vim.bo.tabstop
                end

                return current_indent .. ': ' .. indent_size
            end

            local function fileformat()
                if ignored_filetypes(vim.bo.filetype) then
                    return ''
                end

                local format = vim.bo.fileformat

                if format == 'unix' then
                    return 'lf'
                elseif format == 'dos' then
                    return 'crlf'
                else
                    return 'cr'
                end
            end

            require('lualine').setup({
                options = {
                    theme = 'auto',
                    globalstatus = true,
                    icons_enabled = true,
                    component_separators = {
                        left = "",
                        right = "",
                    },
                    section_separators = {
                        left = "",
                        right = "",
                    },
                },
                sections = {
                    lualine_a = { 'mode' },
                    lualine_b = { 'branch', 'diff', 'diagnostics' },
                    lualine_c = {
                        harpoon_component,
                        filename,
                    },
                    lualine_x = {
                        'filetype'
                    },
                    lualine_y = { 'encoding', fileformat, current_indentation },
                    lualine_z = { 'location' }
                },
            })
        end,
    },
    {
        'neovim/nvim-lspconfig',
        event = { 'BufReadPost' },
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'folke/neodev.nvim',
        },
        config = function()
            require('neodev').setup()
            require('mason').setup({})

            local function tsserver_organize_imports()
                vim.lsp.buf.execute_command({
                    command = '_typescript.organizeImports',
                    arguments = { vim.api.nvim_buf_get_name(0) },
                    title = '',
                })
            end

            local on_attach = function(client, bufnr)
                local map = function(keys, func)
                    vim.keymap.set({ 'n', 'v' }, keys, func, { noremap = true, silent = true })
                end

                map('R', '<cmd>LspRestart<cr>')
                map('<leader>ls', vim.lsp.buf.signature_help)
                map('<leader>lr', vim.lsp.buf.rename)
                map('<leader>la', vim.lsp.buf.code_action)
                map('<leader>lf', function()
                    require('conform').format({ async = true, lsp_fallback = true }, tsserver_organize_imports)
                end)
                map('<leader>wa', vim.lsp.buf.add_workspace_folder)
                map('<leader>wr', vim.lsp.buf.remove_workspace_folder)
                map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols)
            end

            local servers = {
                gopls = {},
                pyright = {},
                rust_analyzer = {},
                v_analyzer = { filetypes = { 'vlang', 'vsh' } },
                tailwindcss = {},
                prismals = {},
                sqlls = {
                    filetypes = { 'sql', 'mysql' },
                    cmd = { 'sql-language-server', 'up', '--method', 'stdio' },
                    root_dir = function()
                        return vim.loop.cwd()
                    end
                },
                html = { filetypes = { 'html', 'twig', 'hbs' } },
                jsonls = {},
                lua_ls = {
                    cmd = { 'lua-language-server --silent' },
                    Lua = {
                        workspace = { checkThirdParty = false },
                        telemetry = { enable = false },
                    },
                },
            }

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

            local mason_lspconfig = require('mason-lspconfig')
            mason_lspconfig.setup({
                ensure_installed = vim.tbl_keys(servers),
            })

            mason_lspconfig.setup_handlers {
                function(server_name)
                    require('lspconfig')[server_name].setup {
                        capabilities = capabilities,
                        on_attach = on_attach,
                        settings = servers[server_name],
                        filetypes = (servers[server_name] or {}).filetypes,
                    }
                end
            }

            local lspconfig = require('lspconfig')

            lspconfig.tsserver.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    experimental = {
                        enableProjectDiagnostics = true,
                    },
                },
                commands = {
                    OrganizeImports = {
                        tsserver_organize_imports,
                        description = 'Organize Imports'
                    }
                }
            })

            vim.filetype.add({
                extension = {
                    v = 'vlang',
                    vsh = 'vlang'
                },
            })

            vim.diagnostic.config({})
        end,
    },
    {
        'lewis6991/gitsigns.nvim',
        opts = {
            current_line_blame = true,
        },
    },
    {
        'zbirenbaum/copilot-cmp',
        event = 'InsertEnter',
        dependencies = { 'zbirenbaum/copilot.lua' },
        config = function()
            require('copilot').setup({
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
                    ['.'] = false,
                },
                copilot_node_command = 'node',
                server_opts_overrides = {},
            })
            require('copilot_cmp').setup()
        end
    },
    {
        'stevearc/conform.nvim',
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
                lua = { 'stylua' },
                javascript = { { 'prettierd', 'prettier' } },
                typescript = { { 'prettierd', 'prettier' } },
            },
        },
    },
    {
        'ThePrimeagen/harpoon',
        branch = 'harpoon2',
    },
    {
        'stevearc/oil.nvim',
        config = function()
            require('oil').setup({
                skip_confirm_for_simple_edits = true,
                keymaps = {
                    ['g?'] = 'actions.show_help',
                    ['<CR>'] = 'actions.select',
                    ['<C-s>'] = 'actions.select_vsplit',
                    ['<C-h>'] = 'actions.select_split',
                    ['<C-t>'] = 'actions.select_tab',
                    ['<C-c>'] = 'actions.close',
                    ['<C-l>'] = 'actions.refresh',
                    ['<Backspace>'] = 'actions.parent',
                    ['_'] = 'actions.open_cwd',
                    ['`'] = 'actions.cd',
                    ['~'] = 'actions.tcd',
                    ['gs'] = 'actions.change_sort',
                    ['gx'] = 'actions.open_external',
                    ['g.'] = 'actions.toggle_hidden',
                    ['g\\'] = 'actions.toggle_trash',
                },
                use_default_keymaps = false,
                view_options = {
                    show_hidden = true,
                }
            })
        end
    },
    {
        'johnfrankmorgan/whitespace.nvim',
        config = function()
            require('whitespace-nvim').setup({
                highlight = 'DiffDelete',
                ignored_filetypes = { 'TelescopePrompt', 'TelescopeResults', 'TelescopePreview', 'Trouble', 'help', 'mason', 'oil', 'lazy' },
                ignore_terminal = true,
                return_cursor = true,
            })
        end
    },
})
