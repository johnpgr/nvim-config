local utils = require("utils")
-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

-- Better terminal buffer
vim.cmd([[
    autocmd TermOpen * startinsert
    autocmd TermOpen * setlocal nonumber norelativenumber
    autocmd TermEnter * setlocal signcolumn=no
    autocmd TermEnter * setlocal nospell
]])

-- Vim dadbod
vim.cmd([[
    autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })
]])

-- Make undercurls work properly
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		-- Disable LSP semantic tokens
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client then
			client.server_capabilities.semanticTokensProvider = nil
		end
	end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufRead" }, {
	pattern = "copilot-chat",
	callback = function()
		-- Remove weird annoying syntax highlighting
		vim.cmd("hi markdownError guibg=none")

		-- This is for in the case where I disabled treesitter highlighting globally
		vim.cmd("set filetype=markdown")
		vim.treesitter.start(0, "markdown")

		-- Local window options
		vim.opt_local.conceallevel = 2
		vim.opt_local.foldcolumn = "0"
		vim.opt_local.signcolumn = "no"
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
	end,
})

-- Function to align text based on a given token
local function align_text(token, lines)
	local max_pos = 0

	-- Find the maximum position of the token in any line
	for _, line in ipairs(lines) do
		local pos = line:find(token)
		if pos and pos > max_pos then
			max_pos = pos
		end
	end

	-- Align each line based on the token position
	local aligned_lines = {}
	for _, line in ipairs(lines) do
		local pos = line:find(token)
		if pos then
			local spaces_to_add = max_pos - pos
			local aligned_line = line:sub(1, pos - 1) .. string.rep(" ", spaces_to_add) .. line:sub(pos)
			table.insert(aligned_lines, aligned_line)
		else
			table.insert(aligned_lines, line)
		end
	end

	return aligned_lines
end

-- Create a Neovim command to call the align_text function
vim.api.nvim_create_user_command("Align", function(opts)
	local token = opts.args
	if #token ~= 1 then
		print("Error: Token must be a single character.")
		return
	end
	local start_line = opts.line1
	local end_line = opts.line2
	local lines = vim.fn.getline(start_line, end_line)
	local aligned_lines = align_text(token, lines)
	vim.fn.setline(start_line, aligned_lines)
end, {
	nargs = 1,
	range = true,
	complete = function()
		return {}
	end,
})

vim.api.nvim_create_autocmd({ "DirChanged", "VimEnter" }, {
	pattern = "*",
	callback = function()
		local local_config = vim.fn.getcwd() .. "/.nvim/init.lua"
		if vim.fn.filereadable(local_config) == 1 then
			vim.cmd("source " .. local_config)
		end
	end,
})

vim.api.nvim_create_user_command("QueryReplace", function()
	local query = ""
	vim.ui.input({ prompt = "Query: " }, function(input)
		query = input
	end)

	if query == "" then
		return
	end

	vim.ui.input({ prompt = "Replace " .. query .. " with: " }, function(replace)
		if replace == "" then
			return
		end
		utils.feedkeys(":%s/" .. query .. "/" .. replace .. "/gc" .. "<CR>")
	end)
end, {
	nargs = 0,
})

vim.api.nvim_create_user_command("CopilotAutoSaveToggle", function()
	vim.g.chat_autosave = not vim.g.chat_autosave
	print("CopilotChat autosave is now " .. (vim.g.chat_autosave and "enabled" or "disabled"))
end, { nargs = 0 })

vim.api.nvim_create_user_command("CopilotCompleteToggle", function()
	local cmd = require("copilot.command")
	vim.g.copilot_enabled = not vim.g.copilot_enabled
	if vim.g.copilot_enabled then
		cmd.enable()
	else
		cmd.disable()
	end
	print("Copilot completion is now " .. (vim.g.copilot_enabled and "enabled" or "disabled"))
end, { nargs = 0 })

-- vim.api.nvim_create_autocmd("UIEnter", {
-- 	callback = function()
-- 		vim.schedule(function()
-- 			local stats = require("lazy").stats()
-- 			local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
-- 			vim.notify(string.format("⚡ Neovim loaded %d/%d plugins in %.2f ms", stats.loaded, stats.count, ms))
-- 		end)
-- 	end,
-- 	once = true,
-- })
