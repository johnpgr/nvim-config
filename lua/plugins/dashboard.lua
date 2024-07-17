return {
    "goolord/alpha-nvim",
    event = "VimEnter",
    keys = { { "<leader>;", "<cmd>Alpha<CR>", desc = "alpha" } },
    config = function()
        local fmt = string.format
        local alpha = require "alpha"
        local dashboard = require "alpha.themes.dashboard"
        local fortune = require "alpha.fortune"
        local stats = require("lazy").stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)

        local installed_plugins = {
            type = "text",
            val = fmt("%s plugins loaded in %s", stats.loaded .. " of " .. stats.count, ms .. "ms"),
            opts = { position = "center", hl = "GitSignsAdd" },
        }

        local v = vim.version()
        local version = {
            type = "text",
            val = fmt("Neovim v%d.%d.%d %s", v.major, v.minor, v.patch, v.prerelease and "(nightly)" or ""),
            opts = { position = "center", hl = "NonText" },
        }

        dashboard.section.buttons.val = {
            dashboard.button("r", "󰁯  Restore session", "<Cmd>lua MiniSessions.read()<CR>"),
            dashboard.button("n", "  New file", ":ene | startinsert<CR>"),
            dashboard.button(
                "f",
                "󰈞  Find file",
                "<Cmd>lua require('utils.telescope-pickers').list_files_cwd()<CR>"
            ),
            dashboard.button("w", "󱎸  Find text", "<Cmd>lua require('utils.telescope-pickers').live_grep()<CR>"),
            dashboard.button("l", "󰒲  Lazy", "<Cmd>Lazy<CR>"),
            dashboard.button("g", "  Git", "<Cmd>LazyGit<CR>"),
            dashboard.button("q", "  Quit", "<cmd>qa<cr>"),
        }

        dashboard.section.footer.val = fortune()
        dashboard.section.footer.opts.hl = "TSEmphasis"

        alpha.setup {
            layout = {
                { type = "padding", val = 4 },
                -- { type = "group", val = neovim_header() },
                { type = "padding", val = 1 },
                installed_plugins,
                { type = "padding", val = 2 },
                dashboard.section.buttons,
                dashboard.section.footer,
                { type = "padding", val = 2 },
                version,
            },
            opts = { margin = 5 },
        }
    end,
}
