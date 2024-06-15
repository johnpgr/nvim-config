---@diagnostic disable: missing-fields

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

local lsp = require "lsp"
local completions = require "completions"
local treesitter = require "treesitter"

require("lazy").setup {
    "morhetz/gruvbox",
    {
        "catppuccin/nvim",
        config = function()
            require("catppuccin").setup {
                no_italic = true,
            }
        end,
    },
    "nvim-lua/plenary.nvim",
    "tpope/vim-fugitive",
    "tpope/vim-rhubarb",
    "tpope/vim-sleuth",
    "tpope/vim-surround",
    "mg979/vim-visual-multi",
    "kdheepak/lazygit.nvim",
    "onsails/lspkind.nvim",
    "folke/trouble.nvim",
    "mbbill/undotree",
    "lewis6991/gitsigns.nvim",
    "nvim-tree/nvim-web-devicons",
    lsp,
    completions,
    treesitter,
    {
        "folke/todo-comments.nvim",
        event = "BufRead",
    },
    {
        "nvim-telescope/telescope.nvim",
        event = "VeryLazy",
        branch = "0.1.x",
        dependencies = {
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond = function() return vim.fn.executable "make" == 1 end,
            },
            {
                "johmsalas/text-case.nvim",
                config = function() require("textcase").setup {} end,
            },
            { "nvim-telescope/telescope-ui-select.nvim" },
        },
        config = function()
            require("telescope").setup {
                defaults = {
                    mappings = {
                        i = {
                            ["<C-u>"] = false,
                        },
                    },
                },
                pickers = {
                    buffers = {
                        theme = "dropdown",
                    },
                },
            }
        end,
        init = function()
            local t = require "telescope"
            t.load_extension "fzf"
            t.load_extension "textcase"
            t.load_extension "ui-select"
        end,
    },
    {
        "nvim-pack/nvim-spectre",
        lazy = true,
        cmd = { "Spectre" },
        config = function()
            require("spectre").setup {
                highlight = {
                    search = "SpectreSearch",
                    replace = "SpectreReplace",
                },
                mapping = {
                    ["send_to_qf"] = {
                        map = "<C-q>",
                        cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
                        desc = "send all items to quickfix",
                    },
                },
            }
        end,
    },
    {
        "iamcco/markdown-preview.nvim",
        ft = "markdown",
        build = function() vim.fn["mkdp#util#install"]() end,
        cmd = {
            "MarkdownPreview",
            "MarkdownPreviewStop",
            "MarkdownPreviewToggle",
        },
    },
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            local path_utils = require "utils.file-path"
            local harpoon = require "harpoon"

            local function string_includes(str, substr) return string.find(str, substr, 1, true) ~= nil end

            local function ignored_filetypes(current_filetype)
                local ignore = {
                    "oil",
                    "toggleterm",
                    "alpha",
                    "harpoon",
                    "TelescopePrompt",
                }

                if vim.tbl_contains(ignore, current_filetype) then return true end

                return false
            end

            local function harpoon_component()
                if ignored_filetypes(vim.bo.filetype) then return "" end

                local total_marks = harpoon:list():length()
                if total_marks == 0 then return "" end

                local current_mark_name = path_utils.current_file_path_in_cwd()
                local current_mark_index = -1

                for index, mark in ipairs(harpoon:list().items) do
                    if string_includes(current_mark_name, mark.value) then current_mark_index = index end
                end

                if current_mark_index == -1 then return string.format("%s/%d", "-", total_marks) end

                return string.format("%d/%d", current_mark_index, total_marks)
            end

            local function current_indentation()
                if ignored_filetypes(vim.bo.filetype) then return "" end

                local current_indent = vim.bo.expandtab and "spaces" or "tab size"

                local indent_size = -1

                if current_indent == "spaces" then
                    indent_size = vim.bo.shiftwidth
                else
                    indent_size = vim.bo.tabstop
                end

                return current_indent .. ": " .. indent_size
            end

            local function fileformat()
                if ignored_filetypes(vim.bo.filetype) then return "" end

                local format = vim.bo.fileformat

                if format == "unix" then
                    return "lf"
                elseif format == "dos" then
                    return "crlf"
                else
                    return "cr"
                end
            end

            require("lualine").setup {
                options = {
                    theme = "auto",
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
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff", "diagnostics" },
                    lualine_c = {
                        harpoon_component,
                        {
                            "filename",
                            path = 1,
                        },
                    },
                    lualine_x = {
                        "filetype",
                    },
                    lualine_y = { "encoding", fileformat, current_indentation },
                    lualine_z = { "location" },
                },
            }
        end,
    },
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
                typescript = { { "prettierd", "prettier" } },
            },
        },
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
    },
    {
        "stevearc/oil.nvim",
        config = function()
            require("oil").setup {
                skip_confirm_for_simple_edits = true,
                keymaps = {
                    ["g?"] = "actions.show_help",
                    ["<CR>"] = "actions.select",
                    ["<C-s>"] = "actions.select_vsplit",
                    ["<C-h>"] = "actions.select_split",
                    ["<C-t>"] = "actions.select_tab",
                    ["<C-c>"] = "actions.close",
                    ["<C-l>"] = "actions.refresh",
                    ["<Backspace>"] = "actions.parent",
                    ["_"] = "actions.open_cwd",
                    ["`"] = "actions.cd",
                    ["~"] = "actions.tcd",
                    ["gs"] = "actions.change_sort",
                    ["gx"] = "actions.open_external",
                    ["g."] = "actions.toggle_hidden",
                    ["g\\"] = "actions.toggle_trash",
                },
                use_default_keymaps = false,
                view_options = {
                    show_hidden = true,
                },
            }
        end,
    },
    {
        "echasnovski/mini.comment",
        event = "VeryLazy",
        dependencies = {
            {
                "JoosepAlviste/nvim-ts-context-commentstring",
                lazy = true,
                opts = {
                    enable_autocmd = false,
                },
            },
        },
        opts = {
            options = {
                custom_commentstring = function()
                    return require("ts_context_commentstring.internal").calculate_commentstring()
                        or vim.bo.commentstring
                end,
            },
            mappings = {
                comment_line = "<C-_>",
                comment_visual = "<C-_>",
            },
        },
    },
    {
        "andweeb/presence.nvim",
        config = function()
            require("presence").setup {
                auto_update = true, -- Update activity based on autocmd events (if `false`, map or manually execute `:lua package.loaded.presence:update()`)
                neovim_image_text = "The One True Text Editor", -- Text displayed when hovered over the Neovim image
                main_image = "neovim", -- Main image display (either "neovim" or "file")
                log_level = nil, -- Log messages at or above this level (one of the following: "debug", "info", "warn", "error")
                debounce_timeout = 10, -- Number of seconds to debounce events (or calls to `:lua package.loaded.presence:update(<filename>, true)`)
                enable_line_number = false, -- Displays the current line number instead of the current project
                blacklist = {}, -- A list of strings or Lua patterns that disable Rich Presence if the current file name, path, or workspace matches
                buttons = true, -- Configure Rich Presence button(s), either a boolean to enable/disable, a static table (`{{ label = "<label>", url = "<url>" }, ...}`, or a function(buffer: string, repo_url: string|nil): table)
                file_assets = {}, -- Custom file asset definitions keyed by file names and extensions (see default config at `lua/presence/file_assets.lua` for reference)
                show_time = true, -- Show the timer
                editing_text = "Editing %s", -- Format string rendered when an editable file is loaded in the buffer (either string or function(filename: string): string)
                file_explorer_text = "Browsing %s", -- Format string rendered when browsing a file explorer (either string or function(file_explorer_name: string): string)
                git_commit_text = "Committing changes", -- Format string rendered when committing changes in git (either string or function(filename: string): string)
                plugin_manager_text = "Managing plugins", -- Format string rendered when managing plugins (either string or function(plugin_manager_name: string): string)
                reading_text = "Reading %s", -- Format string rendered when a read-only or unmodifiable file is loaded in the buffer (either string or function(filename: string): string)
                workspace_text = "Working on %s", -- Format string rendered when in a git repository (either string or function(project_name: string|nil, filename: string): string)
                line_number_text = "Line %s out of %s", -- Format string rendered when `enable_line_number` is set to true (either string or function(line_number: number, line_count: number): string)
            }
        end,
    },
    {
        "aserowy/tmux.nvim",
        config = function() return require("tmux").setup() end,
    },
    {
        "Bekaboo/dropbar.nvim",
        dependencies = {
            "nvim-telescope/telescope-fzf-native.nvim",
        },
    },
    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        keys = { { "<leader>;", "<cmd>Alpha<CR>", desc = "alpha" } },
        config = function()
            local fmt = string.format
            local alpha = require "alpha"
            local dashboard = require "alpha.themes.dashboard"
            local fortune = require "alpha.fortune"

            local header = {
                [[                                                                   ]],
                [[      ████ ██████           █████      ██                    ]],
                [[     ███████████             █████                            ]],
                [[     █████████ ███████████████████ ███   ███████████  ]],
                [[    █████████  ███    █████████████ █████ ██████████████  ]],
                [[   █████████ ██████████ █████████ █████ █████ ████ █████  ]],
                [[ ███████████ ███    ███ █████████ █████ █████ ████ █████ ]],
                [[██████  █████████████████████ ████ █████ █████ ████ ██████]],
            }

            local function neovim_header()
                return vim.iter(ipairs(header))
                    :map(
                        function(i, chars)
                            return {
                                type = "text",
                                val = chars,
                                opts = {
                                    hl = "StartLogo" .. i,
                                    shrink_margin = false,
                                    position = "center",
                                },
                            }
                        end
                    )
                    :totable()
            end

            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)

            local installed_plugins = {
                type = "text",
                val = fmt("%s plugins loaded in %s", stats.loaded .. " of " .. stats.count, ms .. "ms"),
                opts = { position = "center", hl = "GitSignsAdd" },
            }

            local v = vim.version()
            local version = {
                type = "text",
                val = fmt("Neovim v%d.%d.%d %s", v.major, v.minor, v.patch, v.prerelease and "(nightly)" or ""),
                opts = { position = "center", hl = "NonText" },
            }

            dashboard.section.buttons.val = {
                dashboard.button("r", "󰁯  Restore session", "<Cmd>SessionLoad<CR>"),
                dashboard.button("n", "  New file", ":ene | startinsert<CR>"),
                dashboard.button(
                    "f",
                    "󰈞  Find file",
                    "<Cmd>lua require('utils.telescope-pickers').list_files_cwd()<CR>"
                ),
                dashboard.button("w", "󱎸  Find text", "<Cmd>lua require('utils.telescope-pickers').live_grep()<CR>"),
                dashboard.button("l", "󰒲  Lazy", "<Cmd>Lazy<CR>"),
                dashboard.button("g", "  Git", "<Cmd>LazyGit<CR>"),
                dashboard.button("q", "  Quit", "<cmd>qa<cr>"),
            }

            dashboard.section.footer.val = fortune()
            dashboard.section.footer.opts.hl = "TSEmphasis"

            alpha.setup {
                layout = {
                    { type = "padding", val = 4 },
                    { type = "group", val = neovim_header() },
                    { type = "padding", val = 1 },
                    installed_plugins,
                    { type = "padding", val = 2 },
                    dashboard.section.buttons,
                    dashboard.section.footer,
                    { type = "padding", val = 2 },
                    version,
                },
                opts = { margin = 5 },
            }
        end,
    },
    {
        "folke/trouble.nvim",
        opts = {}, -- for default options, refer to the configuration section for custom setup.
        cmd = "Trouble",
    },
    {
        "dmmulroy/ts-error-translator.nvim",
        config = function() require("ts-error-translator").setup() end,
    },
    {
        "razak17/twoslash-queries.nvim",
        keys = {
            { "<leader>lI", "<Cmd>TwoslashQueriesInspect<CR>", desc = "twoslash-queries: inspect" },
        },
        opts = { highlight = "DiagnosticVirtualTextInfo" },
    },
    {
        "dmmulroy/tsc.nvim",
        cmd = "TSC",
        ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        opts = {
            enable_progress_notifications = true,
            auto_open_qflist = true,
        },
        config = function(_, opts)
            require("tsc").setup(opts)

            -- Replace the quickfix window with Trouble when viewing TSC results
            local function replace_quickfix_with_trouble()
                local qflist = vim.fn.getqflist { title = 0, items = 0 }

                if qflist.title ~= "TSC" then return end

                local ok, trouble = pcall(require, "trouble")

                if ok then
                    -- close trouble if there are no more items in the quickfix list
                    if next(qflist.items) == nil then
                        vim.defer_fn(trouble.close, 0)
                        return
                    end

                    vim.defer_fn(function()
                        vim.cmd "cclose"
                        trouble.open "quickfix"
                    end, 0)
                end
            end

            vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
                pattern = "quickfix",
                callback = replace_quickfix_with_trouble,
            })
        end,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("ibl").setup {
                enabled = true,
                indent = {
                    char = "▏",
                },
                scope = {
                    enabled = false,
                },
            }
        end,
    },
}
