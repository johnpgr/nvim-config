---@diagnostic disable: missing-return-value, missing-return
local title_prompt = [[
Generate chat title in filepath-friendly format for:

```
%s
```

Output only the title and nothing else in your response. USE HYPHENS ONLY to separate words.
]]

return {
    {
        -- Copilot autocomplete
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                suggestion = {
                    auto_trigger = true,
                    debounce = 50,
                },
            })

            if not vim.g.copilot_enable then
                require("copilot.command").disable()
            end
        end,
    },
    {
        -- Copilot chat
        "CopilotC-Nvim/CopilotChat.nvim",
        branch = "main",
        event = "BufRead",
        dependencies = {
            { "zbirenbaum/copilot.lua" },
            { "nvim-lua/plenary.nvim" },
        },
        build = "make tiktoken",
        config = function()
            local chat = require("CopilotChat")
            chat.setup({
                callback = function(response)
                    if not vim.g.chat_autosave then
                        return
                    end

                    if vim.g.chat_title then
                        vim.defer_fn(function()
                            chat.save(vim.g.chat_title)
                        end, 100)
                        return
                    end

                    chat.ask(title_prompt:format(response), {
                        headless = true,
                        model = "claude-3.5-sonnet",
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
