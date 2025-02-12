local title_prompt = [[
Generate chat title in filepath-friendly format for:

```
%s
```

Output only the title and nothing else in your response. USE HYPHENS ONLY to separate words.
]]

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
        branch = "main",
        event = "BufReadPre",
        dependencies = {
            { "zbirenbaum/copilot.lua" },
            { "nvim-lua/plenary.nvim" },
        },
        build = "make tiktoken",
        config = function()

            -- Enable Treesitter highlighting for chat buffer
            vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
                pattern = "copilot-chat",
                command = "TSBufEnable highlight",
            })

            local chat = require("CopilotChat")
            chat.setup({
                callback = function(response)
                    if not vim.g.chat_autosave then
                        return
                    end

                    if vim.g.chat_title then
                        chat.save(vim.g.chat_title)
                        return
                    end

                    chat.ask(vim.trim(title_prompt:format(response)), {
                        headless = true,
                        callback = function(gen_response)
                            vim.g.chat_title = vim.trim(gen_response)
                            chat.save(vim.g.chat_title)
                        end,
                    })
                end,
                model = "claude-3.5-sonnet",
                chat_autocomplete = true,
                mappings = {
                    complete = {
                        insert = "",
                    },
                    reset = {
                        normal = "",
                        insert = "",
                    },
                },
            })
        end,
    },
}
