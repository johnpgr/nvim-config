local fortunes = require("fortunes")
local fortune = fortunes()
local M = {}

M.base46 = {
    theme = "blossom_light",
}

M.ui = {
    statusline = { theme = "vscode_colored" },
    cmp = {
        icons_left = false,  -- only for non-atom styles!
        lspkind_text = true,
        style = "atom",      -- default/flat_light/flat_dark/atom/atom_colored
        format_colors = {
            tailwind = true, -- will work for css lsp too
            icon = "󱓻",
        },
    },
    tabufline = {
        enabled = false,
    },
}

M.nvdash = {
    load_on_startup = true,
    buttons = {
        {
            txt = function()
                local v = vim.version()
                return string.format(
                    "Neovim v%d.%d.%d %s",
                    v.major,
                    v.minor,
                    v.patch,
                    v.prerelease and "(nightly)" or ""
                )
            end,
            hl = "NvDashLazy",
            no_gap = true,
        },
        {
            txt = function()
                local stats = require("lazy").stats()
                local ms = math.floor(stats.startuptime) .. " ms"
                return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
            end,
            hl = "NvDashLazy",
        },
        { txt = "  Find File", keys = "Spc f f", cmd = "Telescope find_files" },
        { txt = "󰈚  Recent Files", keys = "Spc f o", cmd = "Telescope oldfiles" },
        { txt = "󰈭  Find Word", keys = "Spc f w", cmd = "Telescope live_grep" },
        { txt = "  Colorschemes", keys = "Spc c s", cmd = "lua require('nvchad.themes').open()" },
        { txt = "  Mappings", keys = "Spc c h", cmd = "NvCheatsheet" },
        { txt = fortune[1] or "", hl = "NvDashLazy", no_gap = true },
        { txt = fortune[2] or "", hl = "NvDashLazy", no_gap = true },
        { txt = fortune[3] or "", hl = "NvDashLazy", no_gap = true },
        { txt = fortune[4] or "", hl = "NvDashLazy", no_gap = true },
        { txt = fortune[5] or "", hl = "NvDashLazy", no_gap = true },
        { txt = fortune[6] or "", hl = "NvDashLazy", no_gap = true },
    },
    header = {},
}

M.colorify = {
    enabled = true,
    mode = "virtual", -- fg, bg, virtual
    virt_text = "󱓻 ",
    highlight = { hex = true, lspvars = true },
}

M.lsp = {
    signature = false,
}

return M
