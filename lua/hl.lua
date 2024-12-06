vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#FF4C4C" }) -- bright red for normal breakpoints
vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#FFB74C" }) -- orange for conditional breakpoints
vim.api.nvim_set_hl(0, "DapBreakpointRejected", { fg = "#767676" }) -- gray for rejected/invalid breakpoints
vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#61AFEF" }) -- blue for logpoints
vim.cmd([[
    highlight! ZenBg guibg=#212121
]])
