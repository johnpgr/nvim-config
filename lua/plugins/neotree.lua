return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    config = function()
        require("neo-tree").setup({
            popup_border_style = "single",
            commands = {
                run_command = function(state)
                    local node = state.tree:get_node()
                    local path = node:get_id()
                    local feedkeys = require("util").feedkeys
                    feedkeys("<C-w>l:SplitrunNew " .. path .. "<C-Left><Left> ")
                end,
            },
            sources = {
                "filesystem",
                "buffers",
                "document_symbols",
            },
            source_selector = {
                winbar = true, -- toggle to show selector on winbar
                sources = {
                    {
                        source = "filesystem",
                        display_name = " 󰉓 Files",
                    },
                    {
                        source = "buffers",
                        display_name = "󰈚 Buffers",
                    },
                    {
                        source = "document_symbols",
                        display_name = " Symbols",
                    },
                },
            },
            window = {
                width = 32,
            },
            filesystem = {
                window = {
                    mappings = {
                        ["."] = "run_command",
                    },
                },
                follow_current_file = {
                    enabled = true,
                },
            },
            buffers = {
                follow_current_file = {
                    enabled = true,
                },
            },
        })
    end,
}
