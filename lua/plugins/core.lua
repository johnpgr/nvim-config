return {
    "nvim-lua/plenary.nvim",
    "tpope/vim-fugitive",
    "tpope/vim-rhubarb",
    "tpope/vim-sleuth",
    "mg979/vim-visual-multi",
    "kdheepak/lazygit.nvim",
    "onsails/lspkind.nvim",
    "folke/trouble.nvim",
    "mbbill/undotree",
    "nvim-tree/nvim-web-devicons",
    "farmergreg/vim-lastplace",
    "xiyaowong/transparent.nvim",
    {
        "Hubro/nvim-splitrun",
        opts = {},
    },
    {
        "echasnovski/mini.surround",
        version = false,
        config = function() require("mini.surround").setup() end,
    },
    { "echasnovski/mini.pairs", version = false, config = function() require("mini.pairs").setup() end },
    { 'echasnovski/mini.align', version = false, config = function() require("mini.align").setup() end },
    {
        "lewis6991/gitsigns.nvim",
        config = function() require("gitsigns").setup() end,
    },
    {
        "folke/todo-comments.nvim",
        event = "BufRead",
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
        "stevearc/oil.nvim",
        config = function()
            require("oil").setup {
                skip_confirm_for_simple_edits = true,
                keymaps = {
                    ["g?"] = "actions.show_help",
                    ["<CR>"] = "actions.select",
                    ["<leader>v"] = "actions.select_vsplit",
                    ["<leader>h"] = "actions.select_split",
                    ["<C-t>"] = "actions.select_tab",
                    ["<C-c>"] = "actions.close",
                    ["<F5>"] = "actions.refresh",
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
                comment_line = "<C-/>",
                comment_visual = "<C-/>",
            },
        },
    },
    {
        "andweeb/presence.nvim",
        config = function()
            require("presence").setup {
                auto_update = true,                             -- Update activity based on autocmd events (if `false`, map or manually execute `:lua package.loaded.presence:update()`)
                neovim_image_text = "The One True Text Editor", -- Text displayed when hovered over the Neovim image
                main_image = "neovim",                          -- Main image display (either "neovim" or "file")
                log_level = nil,                                -- Log messages at or above this level (one of the following: "debug", "info", "warn", "error")
                debounce_timeout = 10,                          -- Number of seconds to debounce events (or calls to `:lua package.loaded.presence:update(<filename>, true)`)
                enable_line_number = false,                     -- Displays the current line number instead of the current project
                blacklist = {},                                 -- A list of strings or Lua patterns that disable Rich Presence if the current file name, path, or workspace matches
                buttons = true,                                 -- Configure Rich Presence button(s), either a boolean to enable/disable, a static table (`{{ label = "<label>", url = "<url>" }, ...}`, or a function(buffer: string, repo_url: string|nil): table)
                file_assets = {},                               -- Custom file asset definitions keyed by file names and extensions (see default config at `lua/presence/file_assets.lua` for reference)
                show_time = true,                               -- Show the timer
                editing_text = "Editing %s",                    -- Format string rendered when an editable file is loaded in the buffer (either string or function(filename: string): string)
                file_explorer_text = "Browsing %s",             -- Format string rendered when browsing a file explorer (either string or function(file_explorer_name: string): string)
                git_commit_text = "Committing changes",         -- Format string rendered when committing changes in git (either string or function(filename: string): string)
                plugin_manager_text = "Managing plugins",       -- Format string rendered when managing plugins (either string or function(plugin_manager_name: string): string)
                reading_text = "Reading %s",                    -- Format string rendered when a read-only or unmodifiable file is loaded in the buffer (either string or function(filename: string): string)
                workspace_text = "Working on %s",               -- Format string rendered when in a git repository (either string or function(project_name: string|nil, filename: string): string)
                line_number_text = "Line %s out of %s",         -- Format string rendered when `enable_line_number` is set to true (either string or function(line_number: number, line_count: number): string)
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
        "folke/trouble.nvim",
        opts = {},
        cmd = "Trouble",
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("ibl").setup {
                enabled = false,
                indent = {
                    char = "▏",
                },
                scope = {
                    enabled = false,
                },
            }
        end,
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {},
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require("noice").setup {
                lsp = {
                    progress = {
                        enabled = false,
                    },
                    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
                    },
                    hover = {
                        silent = true,
                    },
                },
                cmdline = {
                    format = {
                        CMD = { pattern = "^:SplitrunNew", icon = "", lang = "bash" },
                    },
                },
                -- you can enable a preset for easier configuration
                presets = {
                    command_palette = true,       -- position the cmdline and popupmenu together
                    long_message_to_split = true, -- long messages will be sent to a split
                },
            }
        end,
    },
    {
        "nanozuki/tabby.nvim",
        opts = {
            preset = "tab_only",
        },
    },
}
