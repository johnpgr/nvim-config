local utils = require("utils")

return {
    -- Displays keybindings in popup
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        preset = "helix",
        icons = utils.nerd_icons and {} or {
            mappings = false,
            separator = "» ",
            keys = {
                C = "C-",
                M = "M-",
                D = "D-",
                S = "S-",
                CR = "CR",
                Esc = "Esc",
                ScrollWheelDown = "ScrollWheelDown",
                ScrollWheelUp = "ScrollWheelUp",
                NL = "Nul",
                BS = "BS",
                Space = "Space",
                Tab = "Tab",
                F1 = "F1",
                F2 = "F2",
                F3 = "F3",
                F4 = "F4",
                F5 = "F5",
                F6 = "F6",
                F7 = "F7",
                F8 = "F8",
                F9 = "F9",
                F10 = "F10",
                F11 = "F11",
                F12 = "F12",
            },
        },
        win = {
            border = "none",
            padding = { 1, 2, 2, 2 },
        },
    },
}
