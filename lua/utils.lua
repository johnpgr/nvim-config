local M = {}

M.is_neovide = vim.g.neovide ~= nil
M.is_windows = vim.fn.has("win32") == 1

---Utility for keymap creation.
---@param lhs string|string[]
---@param rhs string|function
---@param opts string|table
---@param mode? string|string[]
function M.keymap(lhs, rhs, opts, mode)
	opts = type(opts) == "string" and { desc = opts } or vim.tbl_extend("error", opts --[[@as table]], { buffer = 0 })
	mode = mode or { "n", "v" }

	if type(lhs) == "table" then
		for _, l in ipairs(lhs) do
			vim.keymap.set(mode, l, rhs, opts)
		end
	else
		vim.keymap.set(mode, lhs, rhs, opts)
	end
end

---For replacing certain <C-x>... keymaps.
---@param keys string
function M.feedkeys(keys)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "n", true)
end

function M.toggle_spaces_width()
	local current_width = vim.opt.shiftwidth:get()
	local current_tabstop = vim.opt.tabstop:get()

	if current_width == 2 and current_tabstop == 2 then
		vim.opt.shiftwidth = 4
		vim.opt.tabstop = 4
	else
		vim.opt.shiftwidth = 2
		vim.opt.tabstop = 2
	end
	-- Print a message to indicate the current values
	print("Shiftwidth: " .. vim.opt.shiftwidth:get() .. " Tabstop: " .. vim.opt.tabstop:get())
end

function M.toggle_indent_mode()
	-- Get the current value of 'expandtab' (whether spaces are being used)
	local expandtab = vim.bo.expandtab

	if expandtab then
		-- If spaces are being used, toggle to tabs
		vim.bo.expandtab = false
	else
		-- If tabs are being used, toggle to spaces
		vim.bo.expandtab = true
	end

	-- Retab the buffer to apply the changes
	vim.fn.execute("retab!")

	-- Display a message indicating the toggle is done
	local current_mode = vim.bo.expandtab == true and "Spaces" or "Tabs"
	print("Current indentation mode: " .. current_mode)
end

function M.up_jump_to_error_loc()
	local line = vim.fn.getline(".")
	local file, lnum, col = string.match(line, "([^:]+):(%d+):(%d+)")

	if not (file and lnum and col) then
		return false
	end

	if vim.fn.filereadable(file) ~= 1 then
		vim.notify("File not found: " .. file, vim.log.levels.ERROR)
		return false
	end

	lnum = tonumber(lnum)
	col = tonumber(col)

	-- Find if the file is already open in a buffer
	local bufnr = vim.fn.bufnr(vim.fn.fnamemodify(file, ":p"))
	local win_id = nil

	-- Check if buffer is visible in any window
	if bufnr ~= -1 then
		local wins = vim.fn.getbufinfo(bufnr)[1].windows
		if #wins > 0 then
			win_id = wins[1]
		end
	end

	if win_id then
		-- If buffer is visible, switch to its window
		vim.fn.win_gotoid(win_id)
	else
		-- Check for window above current window
		local window_above = vim.fn.winnr("#")

		if window_above ~= 0 then
			-- Go to window above
			vim.cmd("wincmd k")
			-- Open file in this window
			vim.cmd("edit " .. file)
		else
			-- If no window above, create new split
			vim.cmd("topleft split " .. file)
		end
	end

	-- Move cursor to error position
	vim.api.nvim_win_set_cursor(0, { lnum, col - 1 })

	-- Center the screen on the error
	vim.cmd("normal! zz")

	return true
end

function M.left_jump_to_error_loc()
	local line = vim.fn.getline(".")
	-- First remove the Unicode symbol and any leading spaces
	line = line:gsub("^[^./a-zA-Z0-9]+", "")
	-- Remove any remaining leading whitespace
	line = line:gsub("^%s+", "")

	local file, lnum, col = string.match(line, "([^:]+):(%d+):(%d+)")

	if not (file and lnum and col) then
		vim.notify("No file:line:column pattern found in current line", vim.log.levels.WARN)
		return
	end

	if vim.fn.filereadable(file) ~= 1 then
		vim.notify("File not found: " .. file, vim.log.levels.ERROR)
		return
	end

	lnum = tonumber(lnum)
	col = tonumber(col)

	-- Find if the file is already open in a buffer
	local bufnr = vim.fn.bufnr(vim.fn.fnamemodify(file, ":p"))
	local win_id = nil

	-- Check if buffer is visible in any window
	if bufnr ~= -1 then
		local wins = vim.fn.getbufinfo(bufnr)[1].windows
		if #wins > 0 then
			win_id = wins[1]
		end
	end

	if win_id then
		-- If buffer is visible, switch to its window
		vim.fn.win_gotoid(win_id)
	else
		-- Check for window to the left of current window
		local current_winnr = vim.fn.winnr()
		vim.cmd("wincmd h")
		local window_left = vim.fn.winnr()
		-- Go back to original window
		vim.cmd(current_winnr .. "wincmd w")

		if window_left ~= current_winnr then
			-- Go to window on the left
			vim.cmd("wincmd h")
			-- Open file in this window
			vim.cmd("edit " .. file)
		else
			-- If no window on the left, create new vsplit
			vim.cmd("topleft vsplit " .. file)
		end
	end

	-- Move cursor to error position
	vim.api.nvim_win_set_cursor(0, { lnum, col - 1 })

	-- Center the screen on the error
	vim.cmd("normal! zz")
end

function M.load_colorscheme()
	local json_file = vim.fn.stdpath("config") .. "/colorscheme.json"
	local file = io.open(json_file, "r")
    local default_scheme = "default"

	if file then
		local content = file:read("*all")
		file:close()

		local ok, data = pcall(vim.json.decode, content)
		if ok and data.colorscheme then
			-- Try to set the colorscheme, fallback to default if it fails
			pcall(vim.cmd.colorscheme, data.colorscheme)
			return
		end
	end

	-- Fallback to default if anything fails
	vim.cmd.colorscheme(default_scheme)
end

function M.get_compile_tasks()
	local tasks = {}
	require("overseer.template").list({ dir = vim.fn.getcwd() }, function(templates)
		for _, template in ipairs(templates) do
			if template.aliases ~= nil and template.tags ~= nil and vim.tbl_contains(template.tags, "BUILD") then
				local task = {
					name = template.name,
					cmd = template.aliases[1]:gsub("shell: ", ""),
				}
				table.insert(tasks, task)
			end
		end
	end)
	return tasks
end

return M
