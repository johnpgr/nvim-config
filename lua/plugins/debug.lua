return {
	"mfussenegger/nvim-dap",
	cmd = {
		"DapNew",
		"DapContinue",
		"DapStepOver",
		"DapStepInto",
		"DapStepOut",
		"DapToggleBreakpoint",
	},
	dependencies = {
		{
			"rcarriga/nvim-dap-ui",
			opts = {},
		},
		{ "theHamsta/nvim-dap-virtual-text", opts = {} },
		"nvim-neotest/nvim-nio",
	},
	config = function()
		local dap = require("dap")

		for _, group in pairs({
			"DapBreakpoint",
			"DapBreakpointCondition",
			"DapBreakpointRejected",
			"DapLogPoint",
		}) do
			vim.fn.sign_define(group, { text = "●", texthl = group })
		end

		-- Decides when and how to jump when stopping at a breakpoint
		-- The order matters!
		--
		-- (1) If the line with the breakpoint is visible, don't jump at all
		-- (2) If the buffer is opened in a tab, jump to it instead
		-- (3) Else, create a new tab with the buffer
		--
		-- This avoid unnecessary jumps
		dap.defaults.fallback.switchbuf = "usevisible,usetab,newtab"

		-- Adapters
		-- C, C++, Rust, Zig
		dap.adapters.codelldb = {
			type = "server",
			port = "${port}",
			executable = {
				command = "codelldb",
				args = { "--port", "${port}" },
			},
		}

		dap.configurations.c = {
			{
				name = "Launch",
				type = "codelldb",
				request = "launch",
				program = "${workspaceFolder}/out/${fileBasenameNoExtension}",

				-- program = function()
				--     return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				-- end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
			},
		}

		dap.configurations.odin = {
			{
				name = "Launch",
				type = "codelldb",
				request = "launch",
				-- program = "${workspaceFolder}/out/${fileBasenameNoExtension}",

				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
			},
		}

		dap.configurations.zig = {
			{
				name = "Launch",
				type = "codelldb",
				request = "launch",
				program = "${workspaceFolder}/zig-out/bin/${workspaceFolderBasename}",
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
				args = {},
			},
		}
	end,
}
