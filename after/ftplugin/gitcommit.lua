local keymap = require("utils").keymap
local chat = require("CopilotChat")
local commit_prompt = require("CopilotChat.config.prompts").Commit

keymap("<leader>cm", function()
	vim.notify("Generating commit message...", vim.log.levels.INFO, { title = "CopilotChat" })
	chat.ask(commit_prompt.prompt, {
		context = commit_prompt.context,
		headless = true,
		model = "claude-3.5-sonnet",
		callback = function(response)
			local commit_msg = response:match("```gitcommit\n([^\n\r]+)")
			if commit_msg then
				vim.api.nvim_put({ commit_msg }, "c", true, true)
			end
		end,
	})
end, "Generate commit message")
