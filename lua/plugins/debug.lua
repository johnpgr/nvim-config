return {
    {
        "mfussenegger/nvim-dap",
        event = "VeryLazy",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio",
        },
        config = function ()
            local dap = require("dap")
            local dap_ui = require("dapui")
            local dap_virtual_text = require("nvim-dap-virtual-text")

            dap_ui.setup()
            dap_virtual_text.setup()
        end
    }
}
