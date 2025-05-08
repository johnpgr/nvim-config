return {
    "nvim-flutter/flutter-tools.nvim",
    ft = "dart",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        require("flutter-tools").setup({
            debugger = {
                enabled = false,
                register_configurations = function(_)
                    require("dap").adapters.dart = {
                        type = "executable",
                        command = vim.fn.stdpath("data") .. "/mason/bin/dart-debug-adapter",
                        args = { "flutter" },
                    }
                    require("dap").configurations.dart = {
                        type = "dart",
                        request = "launch",
                        name = "Launch flutter",
                        dartSdkPath = ".local/flutter/bin/cache/dart-sdk/",
                        flutterSdkPath = ".local/flutter",
                        program = "${workspaceFolder}/lib/main.dart",
                        cwd = "${workspaceFolder}",
                    }
                end,
            },
            dev_log = {
                open_cmd = "tabedit",
            },
        })
    end,
}
