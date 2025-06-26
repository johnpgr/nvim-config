-- Declare a global function to retrieve the current directory
function _G.get_oil_winbar()
	local dir = require("oil").get_current_dir()
	if dir then
		-- Remove trailing slash unless dir is just "/"
		dir = dir:len() > 1 and dir:gsub("/$", "") or dir
		return dir .. ":"
	else
		-- If there is no current directory (e.g. over ssh), just show the buffer name
		return vim.api.nvim_buf_get_name(0)
	end
end

-- Create highlight groups for file permissions
vim.api.nvim_set_hl(0, "OilPermissionRead", { fg = "#ffb74c" })
vim.api.nvim_set_hl(0, "OilPermissionWrite", { fg = "#eb5f6a" })
vim.api.nvim_set_hl(0, "OilPermissionExecute", { fg = "#78d0bd" })

local permission_hlgroups = {
	["-"] = "NonText",
	["r"] = "OilPermissionRead",
	["w"] = "OilPermissionWrite",
	["x"] = "OilPermissionExecute",
}

return {
	"stevearc/oil.nvim",
	opts = {
		columns = {
			{
				"permissions",
				highlight = function(permission_str)
					local hls = {}
					for i = 1, #permission_str do
						local char = permission_str:sub(i, i)
						table.insert(hls, { permission_hlgroups[char], i - 1, i })
					end
					return hls
				end,
			},
			{ "size", highlight = "Special" },
			{ "mtime", highlight = "Number" },
			vim.g.nerdicons_enable and {
				"icon",
				add_padding = false,
			} or {},
		},
		skip_confirm_for_simple_edits = true,
		keymaps = {
			["q"] = "actions.close",
			["<RightMouse>"] = "<LeftMouse><cmd>lua require('oil.actions').select.callback()<CR>",
			["?"] = "actions.show_help",
			["<CR>"] = "actions.select",
			["<leader>v"] = {
				"actions.select",
				opts = { vertical = true },
				desc = "Open the entry in a vertical split",
			},
			["<leader>h"] = {
				"actions.select",
				opts = { horizontal = true },
				desc = "Open the entry in a horizontal split",
			},
            ["H"] = {
                "actions.toggle_hidden",
            },
            ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
			["<leader>p"] = "actions.preview",
			["<F5>"] = "actions.refresh",
            ["H"] = "actions.toggle_hidden",
            ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
			["<F1>"] = function()
				local oil = require("oil")
				local entry = oil.get_cursor_entry()
				local cwd = oil.get_current_dir()

				if not entry then
					return
				end

				vim.ui.input(
					{ prompt = "Enter command: " },
					function(cmd)
                        if not cmd then
                            return
                        end

						local full_path = cwd .. entry.name

						local function show_terminal(cmd_array)
							vim.cmd("botright new")
							local buf = vim.api.nvim_get_current_buf()
							vim.fn.jobstart(cmd_array, {
								on_exit = function(_, code)
									if code ~= 0 then
										vim.notify("Command exited with code: " .. code, vim.log.levels.WARN)
									end
								end,
                                term = true,
							})
							vim.cmd("startinsert")
						end


						if cmd and cmd ~= "" then
							local command_string = cmd .. " " .. vim.fn.shellescape(full_path)
							show_terminal({ "sh", "-c", command_string })
						else
							local stat = vim.uv.fs_stat(full_path)
							if stat and stat.type == "file" then
								if bit.band(stat.mode, tonumber("100", 8)) > 0 then
									show_terminal({ full_path })
								else
									vim.ui.select({ "Yes", "No" }, {
										prompt = "File is not executable. Make it executable and run?",
									}, function(choice)
										if choice == "Yes" then
											local chmod_res = vim.system({ "chmod", "+x", full_path }):wait()
											if chmod_res.code == 0 then
												vim.notify("Made file executable: " .. entry.name)
												show_terminal({ full_path })
											else
												vim.notify(
													"Failed to make file executable: " .. entry.name,
													vim.log.levels.ERROR
												)
											end
										else
											vim.notify("Aborted execution of: " .. entry.name)
										end
									end)
								end
							else
								vim.notify("Not a valid file: " .. entry.name, vim.log.levels.WARN)
							end
						end
					end
				)
			end,
		},
		win_options = {
			winbar = "%!v:lua.get_oil_winbar()",
			number = false,
			relativenumber = false,
		},
		confirmation = {
			border = "rounded",
		},
		view_options = {
			is_hidden_file = function(name, _)
				local m = name:match("^%.")
				return m ~= nil and name ~= ".."
			end,
		},
		use_default_keymaps = false,
		watch_for_changes = true,
		constrain_cursor = "name",
	},
}
