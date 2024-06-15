return {
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        build = ":TSUpdate",
        config = function()
            ---@diagnostic disable-next-line: missing-fields
            require("nvim-treesitter.configs").setup {
                autotag = {
                    enable = true,
                },
                ensure_installed = {
                    "c",
                    "cpp",
                    "go",
                    "lua",
                    "python",
                    "rust",
                    "tsx",
                    "javascript",
                    "typescript",
                    "vimdoc",
                    "vim",
                    "v",
                },
                auto_install = true,
                highlight = { enable = true },
                indent = { enable = false },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<c-space>",
                        node_incremental = "<c-space>",
                        scope_incremental = "<c-s>",
                        node_decremental = "<M-space>",
                    },
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
                            ["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
                            ["l="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
                            ["r="] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },
                            ["a:"] = { query = "@property.outer", desc = "Select outer part of an object property" },
                            ["i:"] = { query = "@property.inner", desc = "Select inner part of an object property" },
                            ["l:"] = { query = "@property.lhs", desc = "Select left part of an object property" },
                            ["r:"] = { query = "@property.rhs", desc = "Select right part of an object property" },
                            ["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
                            ["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },
                            ["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
                            ["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },
                            ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
                            ["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },
                            ["af"] = {
                                query = "@function.outer",
                                desc = "Select outer part of a method/function definition",
                            },
                            ["if"] = {
                                query = "@function.inner",
                                desc = "Select inner part of a method/function definition",
                            },
                            ["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
                            ["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = {
                            ["]f"] = "@function.outer",
                            ["]c"] = "@class.outer",
                        },
                        goto_next_end = {
                            ["]F"] = "@function.outer",
                            ["]C"] = "@class.outer",
                        },
                        goto_previous_start = {
                            ["[f"] = "@function.outer",
                            ["[c"] = "@class.outer",
                        },
                        goto_previous_end = {
                            ["[F"] = "@function.outer",
                            ["[C"] = "@class.outer",
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ["<leader>sn"] = "@parameter.inner",
                        },
                        swap_previous = {
                            ["<leader>sp"] = "@parameter.inner",
                        },
                    },
                },
            }
        end,
    },
}
