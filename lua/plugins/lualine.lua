local utils = require("utils")

local disabled_filetypes = {
	"oil",
	"toggleterm",
	"alpha",
	"TelescopePrompt",
	"NeogitStatus",
}

---@diagnostic disable: undefined-field, deprecated
return {
	"nvim-lualine/lualine.nvim",
	enabled = true,
	config = function()
		local function current_indentation()
			local current_indent = vim.bo.expandtab and "spaces" or "tab size"

			local indent_size = -1

			if current_indent == "spaces" then
				indent_size = vim.bo.shiftwidth
			else
				indent_size = vim.bo.tabstop
			end

			return current_indent .. " " .. indent_size
		end

		local function fileformat()
			local format = vim.bo.fileformat

			if format == "unix" then
				return "lf"
			elseif format == "dos" then
				return "crlf"
			else
				return "cr"
			end
		end

		require("lualine").setup({
			options = {
				theme = "auto",
				globalstatus = true,
				icons_enabled = utils.nerd_icons,
				disabled_filetypes = disabled_filetypes,
				component_separators = {
					left = "",
					right = "",
				},
				section_separators = {
					left = "",
					right = "",
				},
			},
			sections = {
				lualine_a = {},
				lualine_b = { "branch" },
				lualine_c = {
					{
						"filename",
						path = 3,
					},
				},
				lualine_x = {
					{
						"lsp_status",
						icon = "",
						symbols = {
							done = "",
						},
						ignore_lsp = { "copilot", "eslint", "htmx" },
					},
					fileformat,
					current_indentation,
				},
				lualine_y = { "location", "progress" },
				lualine_z = {},
			},
		})
	end,
}
