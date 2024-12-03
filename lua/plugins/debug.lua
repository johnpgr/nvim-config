return {
    {
        "mfussenegger/nvim-dap",
        event = "VeryLazy",
        dependencies = {
            {
                "rcarriga/nvim-dap-ui",
                opts = {
                    icons = {
                        expanded = "󰅀",
                        collapsed = "󰅂",
                        current_frame = "󰅂",
                    },
                    layouts = {
                        {
                            elements = { "console", "watches" },
                            position = "bottom",
                            size = 15,
                        },
                    },
                    expand_lines = false,
                    controls = {
                        enabled = false,
                    },
                    floating = {
                        border = "rounded",
                    },
                    render = {
                        indent = 2,
                        -- Hide variable types as C++'s are verbose
                        max_type_length = 0,
                    },
                },
            },
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local dap = require("dap")
            local dap_ui = require("dapui")
            local dap_virtual_text = require("nvim-dap-virtual-text")

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
            -- C, C++, Rust
            dap.adapters.codelldb = {
                type = "server",
                port = "${port}",
                executable = {
                    command = "codelldb",
                    args = { "--port", "${port}" },
                },
            }
        end,
    },
}
