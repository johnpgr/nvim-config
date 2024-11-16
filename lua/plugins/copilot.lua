return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                suggestion = {
                    auto_trigger = true,
                },
            })
        end,
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        branch = "canary",
        event = "VeryLazy",
        dependencies = {
            { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
            { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
        },
        build = "make tiktoken", -- Only on MacOS or Linux
        config = function()
            require("CopilotChat").setup({
                model = "claude-3.5-sonnet",
                mappings = {
                    complete = {
                        insert = "",
                    },
                    reset = {
                        normal = "<C-r>",
                        insert = "<C-r>",
                    },
                },
            })
            require("CopilotChat.integrations.cmp").setup()
        end,
    },
}
