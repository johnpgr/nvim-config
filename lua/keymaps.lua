local utils = require("utils")
local keymap = utils.keymap
local feedkeys = utils.feedkeys
local is_neovide = utils.is_neovide

keymap("<leader>fw", "<cmd>Telescope live_grep<cr>", "Live grep")
keymap("<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Find Word (Current buffer)")
keymap("<leader>ff", "<cmd>Telescope find_files<cr>", "Find Files")
keymap("<leader>fr", "<cmd>Telescope oldfiles<cr>", "Recent Files")
keymap("<leader><space>", "<cmd>Telescope buffers<cr>", "Open Buffers")
keymap("<leader>fs", "<cmd>Telescope spell_suggest<cr>", "Spell Suggestions")
keymap("<leader>fh", "<cmd>Telescope help_tags<cr>", "Help Tags")
keymap("<leader>fH", "<cmd>Telescope highlights<cr>", "Highlights")
keymap({ "<C-/>", "<C-_>" }, "<cmd>Telescope resume<cr>", "Previous Picker")
keymap("<leader>T", "<cmd>Telescope colorscheme<cr>", "Theme Picker")
keymap("<A-x>", "<cmd>Telescope commands<cr>", "Commands")
keymap("<leader>fm", "<cmd>Telescope reloader<cr>", "Modules")
keymap("<leader>fo", "<cmd>Telescope vim_options<cr>", "Vim Options")
keymap("<leader>fc", function()
	require("telescope.builtin").find_files({
		prompt_title = "Find Config Files",
		cwd = vim.fn.stdpath("config"),
	})
end, "Find Config Files")
keymap("<leader>b", "<cmd>Telescope file_browser<cr>", "Browse Files")

if is_neovide then
	keymap("<A-s>", "<cmd>Telescope projects<cr>", "Find Projects")
end

-- keymap("<leader>b", ":Neotree<cr>", "Neotree toggle")
keymap("<leader>tS", utils.toggle_spaces_width, "Toggle shift width")
keymap("<leader>ti", utils.toggle_indent_mode, "Toggle indentation mode")
keymap("<leader>e", "<cmd>Oil<cr>", "Explorer")
keymap("<leader>L", "<cmd>Lazy<cr>", "Lazy.nvim")
keymap("<leader>u", "<cmd>UndotreeToggle<cr>", "UndoTree")
keymap("<C-k>", require("tmux").move_top, "Focus top split")
keymap("<C-l>", require("tmux").move_right, "Focus right split")
keymap("<C-j>", require("tmux").move_bottom, "Focus bottom split")
keymap("<C-h>", require("tmux").move_left, "Focus left split")
keymap("<A-k>", require("tmux").resize_top, "Focus top split")
keymap("<A-l>", require("tmux").resize_right, "Focus right split")
keymap("<A-j>", require("tmux").resize_bottom, "Focus bottom split")
keymap("<A-h>", require("tmux").resize_left, "Focus left split")
keymap("<A-=>", "<C-w>=", "Reset splits sizes")
keymap("<leader>sv", "<cmd>vsp<cr><C-w>l", "New vertical split (relative)")
keymap("<leader>sV", "<cmd>bo vsp<cr>", "New vertical split (absolute)")
keymap("<leader>sh", "<cmd>sp<cr>", "New horizontal split (relative)")
keymap("<leader>sH", "<cmd>bo sp<cr>", "New horizontal split (absolute)")
keymap("<Esc>", "<cmd>noh<cr>", "Clear search highlights", "n")
keymap("n", "nzz", "Jump next match", "n")
keymap("]d", function()
	vim.diagnostic.jump({ count = 1, float = true })
	feedkeys("zz")
end, { desc = "Better jump next diagnostic", remap = true }, "n")
keymap("[d", function()
	vim.diagnostic.jump({ count = -1, float = true })
	feedkeys("zz")
end, { desc = "Better jump prev diagnostic", remap = true }, "n")
keymap("J", ":m '>+1<CR>gv=gv", "Move line down", "v")
keymap("K", ":m '<-2<CR>gv=gv", "Move line up", "v")
keymap("<", "<gv", "Keep selection when indenting multiple lines", "v")
keymap(">", ">gv", "Keep selection when indenting multiple lines", "v")
keymap("J", ":m '>+1<CR>gv=gv", "Move line down", "v")
keymap("K", ":m '<-2<CR>gv=gv", "Move line up", "v")
keymap("<leader>i", "<cmd>Inspect<cr>", "Inspect")
keymap("<leader>zm", "<cmd>ZenMode<cr>", "Zen mode")
keymap("<leader>ts", function()
	---@diagnostic disable-next-line: undefined-field
	vim.opt.spell = not vim.opt.spell:get()
end, "Toggle spellchecking")
keymap("yig", ":%y<CR>", "Yank buffer", "n")
keymap("vig", "ggVG", "Visual select buffer", "n")
keymap("cig", ":%d<CR>i", "Change buffer", "n")
keymap("<leader>o", "<cmd>Outline<CR>", "Outline")
keymap("K", utils.smart_hover, "LSP: Hover", "n")
keymap("gd", function()
	if utils.up_jump_to_error_loc() then
		return
	else
		vim.lsp.buf.definition()
	end
end, "LSP: Goto definition", "n")
keymap("gD", vim.lsp.buf.type_definition, "LSP: Goto type definition", "n")
keymap("gr", vim.lsp.buf.references, "LSP: Goto references", "n")
keymap({ "<F2>", "<leader>lr" }, vim.lsp.buf.rename, "LSP: Rename variable", "n")
keymap("<leader>lc", vim.lsp.buf.code_action, "LSP: Code actions")
keymap("gs", vim.lsp.buf.signature_help, "LSP: Signature help")
keymap("<C-s>", vim.lsp.buf.signature_help, "LSP: Signature help", "i")
keymap({ "<A-F>", "<leader>lf" }, function()
	require("conform").format({
		async = true,
		stop_after_first = true,
		lsp_format = "fallback",
	})
end, "LSP: Format buffer")
keymap("<leader>df", vim.diagnostic.open_float, "Diagnostics: Open Hover")
keymap("<leader>dl", vim.diagnostic.setqflist, "Diagnostics: Set quickfix list", "n")
keymap("<leader>dr", function()
	for _, client in ipairs(vim.lsp.get_clients()) do
		require("workspace-diagnostics").populate_workspace_diagnostics(client, 0)
	end
end, "Diagnostics: Refresh")
keymap("<leader>lh", "<cmd>checkhealth vim.lsp<cr>", "LSP: Check health")

keymap("<leader>tn", "<cmd>tabnew<cr>", "Open new tab")
keymap("<Esc>", "<C-\\><C-n>", "Terminal mode easy exit", "t")
keymap("]t", "<cmd>tabnext<cr>", "Tab next")
keymap("[t", "<cmd>tabprevious<cr>", "Tab previous")
keymap("<leader>qf", function()
	local qf_exists = false
	for _, win in pairs(vim.fn.getwininfo()) do
		if win.quickfix == 1 then
			qf_exists = true
		end
	end
	if qf_exists then
		vim.cmd.cclose()
	else
		vim.cmd.copen()
	end
end, "Quickfixlist toggle")
keymap("]q", function()
	local qf_list = vim.fn.getqflist()
	local qf_length = #qf_list
	if qf_length == 0 then
		return
	end

	local current_idx = vim.fn.getqflist({ idx = 0 }).idx
	if current_idx >= qf_length then
		vim.cmd("cfirst")
	else
		vim.cmd("cnext")
	end
	vim.cmd("copen")
end, "Quickfixlist next")

keymap("[q", function()
	local qf_list = vim.fn.getqflist()
	local qf_length = #qf_list
	if qf_length == 0 then
		return
	end

	local current_idx = vim.fn.getqflist({ idx = 0 }).idx
	if current_idx <= 1 then
		vim.cmd("clast")
	else
		vim.cmd("cprevious")
	end
	vim.cmd("copen")
end, "Quickfixlist previous")

local function parse_history_path(file)
	return vim.fn.fnamemodify(file, ":t:r")
end

local function format_display_name(filename)
	filename = filename:gsub("%.%w+$", "")
	return filename:gsub("%-", " "):gsub("^%w", string.upper)
end

local function find_chat_history()
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	local chat = require("CopilotChat")
	require("telescope.builtin").find_files({
		prompt_title = "CopilotChat History",
		cwd = chat.config.history_path,
		hidden = true,
		follow = true,
		layout_config = {
			height = 0.3,
		},
		find_command = { "rg", "--files", "--sortr=modified" },
		entry_maker = function(entry)
			local full_path = chat.config.history_path .. "/" .. entry
			---@diagnostic disable-next-line: undefined-field
			local stat = vim.loop.fs_stat(full_path)
			local mtime = stat and stat.mtime.sec or 0
			local display_time = stat and os.date("%d-%m-%Y %H:%M", mtime) or "Unknown"
			local display_name = format_display_name(entry)
			return {
				value = entry,
				display = string.format("%s | %s", display_time, display_name),
				ordinal = string.format("%s %s", display_time, display_name),
				path = entry,
				index = -mtime,
			}
		end,
		attach_mappings = function(prompt_bufnr, map)
			actions.select_default:replace(function()
				actions.close(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				local path = selection.value
				local parsed = parse_history_path(path)
				vim.g.chat_title = parsed
				chat.load(parsed)
				chat.open()
			end)

			local function delete_history()
				local selection = action_state.get_selected_entry()
				if not selection then
					return
				end

				local full_path = chat.config.history_path .. "/" .. selection.value

				-- Confirm deletion
				vim.ui.select({ "Yes", "No" }, {
					prompt = "Delete chat history: " .. format_display_name(selection.value) .. "?",
					telescope = { layout_config = { width = 0.3, height = 0.3 } },
				}, function(choice)
					if choice == "Yes" then
						vim.fn.delete(full_path)
						find_chat_history()
					end
				end)
			end

			map("i", "<C-d>", delete_history)
			map("n", "D", delete_history)
			return true
		end,
	})
end

keymap("<leader>ch", find_chat_history, "CopilotChat History")
keymap("<leader>cc", "<cmd>CopilotChatToggle<cr>", "CopilotChat Toggle")
keymap("<leader>cp", "<cmd>CopilotChatPrompts<cr>", "CopilotChat Prompts")
keymap("<leader>cx", function()
	vim.g.chat_title = nil
	require("CopilotChat").reset()
end, "CopilotChat Reset")
keymap("<leader>ca", function()
	vim.g.chat_autosave = false
	local prompt = vim.fn.input("Ask Copilot: ")
	if prompt == "" then
		return
	end

	require("CopilotChat").ask(prompt, {
		clear_chat_on_new_prompt = true,
		window = {
			border = "rounded",
			title = "",
			layout = "float",
			relative = "cursor",
			width = 0.8,
			height = 0.4,
			row = 1,
		},
		selection = require("CopilotChat.select").visual,
		context = "buffer",
		callback = function()
			---@diagnostic disable-next-line: missing-return
			vim.g.chat_autosave = true
		end,
	})
end, "CopilotChat Ask")

keymap("<leader>th", "<cmd>TSToggle highlight<cr>", "Toggle treesitter highlight")

keymap("]h", function()
	if vim.wo.diff then
		vim.cmd.normal({ "]c", bang = true })
	else
		vim.cmd("Gitsigns next_hunk")
	end
end, "Goto next hunk")
keymap("[h", function()
	if vim.wo.diff then
		vim.cmd.normal({ "[c", bang = true })
	else
		vim.cmd("Gitsigns prev_hunk")
	end
end, "Goto prev hunk")
keymap("<leader>hs", "<cmd>Gitsigns stage_hunk<cr>", "Hunk Stage", { "n", "v" })
keymap("<leader>hs", "<cmd>Gitsigns stage_hunk<cr>", "Hunk Stage", { "n", "v" })
keymap("<leader>hr", "<cmd>Gitsigns reset_hunk<cr>", "Hunk Reset")
keymap("<leader>hu", "<cmd>Gitsigns undo_stage_hunk<cr>", "Hunk Undo Stage")
keymap("<leader>gb", "<cmd>Gitsigns blame<cr>", "Git Blame")
keymap("<leader>gd", "<cmd>Gitsigns diffthis<cr>", "Git Diff")
keymap("<leader>gB", "<cmd>Gitsigns toggle_current_line_blame<cr>", "Git Blame inline")
keymap("<leader>hp", "<cmd>Gitsigns preview_hunk<cr>", "Hunk Preview")
keymap("<leader>hi", "<cmd>Gitsigns preview_hunk_inline<cr>", "Toggle Deleted")
keymap("<leader>hd", "<cmd>Gitsigns toggle_word_diff<cr>", "Toggle Word diff")
keymap("<leader>dv", function()
	local diffview = require("diffview")
	local diffview_tab_exists = false
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		local buf_name = vim.api.nvim_buf_get_name(buf)
		if buf_name:match("^diffview://") then
			diffview_tab_exists = true
			break
		end
	end

	if diffview_tab_exists then
		diffview.close({})
	else
		diffview.open({})
	end
end, "Diffview Toggle")

keymap("vah", "<cmd>Gitsigns select_hunk<CR>", { silent = true }, "n")
keymap("ah", "<cmd>Gitsigns select_hunk<CR>", { silent = true }, "v")
keymap({ "<leader>gg", "<M-g>" }, function()
	require("neogit").open({ kind = "replace" })
end, "Neogit")

keymap("<leader>dau", function()
	require("dapui").toggle({ reset = true })
end, "Toggle DAP UI")
keymap("<leader>dab", function()
	require("dap").list_breakpoints()
end, "DAP Breakpoints")
keymap("<leader>das", function()
	local widgets = require("dap.ui.widgets")
	local view = widgets.centered_float(widgets.scopes, { border = "rounded" })

	vim.api.nvim_buf_set_keymap(view.buf, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
	vim.api.nvim_buf_set_keymap(view.buf, "n", "<Esc>", "<cmd>close<CR>", { noremap = true, silent = true })
	vim.api.nvim_buf_set_keymap(view.buf, "n", "<C-c>", "<cmd>close<CR>", { noremap = true, silent = true })
end, "DAP Scopes")
keymap("<F1>", function()
	local widgets = require("dap.ui.widgets")
	local view = widgets.hover(nil, { border = "rounded" })

	vim.api.nvim_buf_set_keymap(view.buf, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
	vim.api.nvim_buf_set_keymap(view.buf, "n", "<Esc>", "<cmd>close<CR>", { noremap = true, silent = true })
	vim.api.nvim_buf_set_keymap(view.buf, "n", "<C-c>", "<cmd>close<CR>", { noremap = true, silent = true })
end, "DAP Hover")
keymap("<leader>dat", "<CMD>DapTerminate<CR>", "DAP Terminate")
keymap("<leader>dac", "<CMD>DapContinue<CR>", "DAP Continue")
keymap("<leader>dar", function()
	require("dap").run_to_cursor()
end, "Run to Cursor")
keymap({ "<leader>tb", "<F9>" }, "<CMD>DapToggleBreakpoint<CR>", "Toggle Breakpoint")
keymap({ "]S", "<F10>" }, "<CMD>DapStepOver<CR>", "Step Over")
keymap({ "]s", "<F11>" }, "<CMD>DapStepInto<CR>", "Step Into")
keymap({ "]o", "<F12>" }, "<CMD>DapStepOut<CR>", "Step Out")

keymap("<leader>\\", "<cmd>OverseerToggle<cr>", "Task view")
keymap("<leader>r", "<cmd>OverseerRun<cr>", "Task Run")

keymap("<A-r>", "<cmd>Recompile<cr>", "Recompile")

keymap("<leader>ig", "<cmd>IBLToggle<cr>", "Indent Guides: Toggle")
keymap("<leader>db", "<cmd>DBUIToggle<cr>", "DBUI Toggle")
keymap("<leader>tc", "<cmd>CopilotCompleteToggle<cr>", "Github Copilot Toggle")

keymap("<leader>C", function()
	local compile = require("compile-mode")
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local ivy = require("telescope.themes").get_ivy

	local tasks = utils.get_compile_tasks()
	if #tasks == 0 then
		vim.notify("No tasks available", vim.log.levels.WARN)
		return
	end

	pickers
		.new(
			ivy({
				previewer = false,
				layout_config = {
					height = 0.3,
				},
				results_title = false,
			}),
			{
				prompt_title = "Compile Tasks",
				finder = finders.new_table({
					results = tasks,
					entry_maker = function(entry)
						return {
							value = entry,
							display = entry.name,
							ordinal = entry.name,
						}
					end,
				}),
				sorter = conf.generic_sorter({}),
				attach_mappings = function(prompt_bufnr)
					actions.select_default:replace(function()
						actions.close(prompt_bufnr)
						local selection = action_state.get_selected_entry()
						if selection and selection.value.cmd then
							compile.compile({ args = selection.value.cmd })
						end
					end)
					return true
				end,
			}
		)
		:find()
end, "Compile from tasks.json")
