return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  keys = { { "<leader>;", "<cmd>Alpha<CR>", desc = "Dashboard" } },
  config = function()
    local fmt = string.format
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")
    local fortune = require("alpha.fortune")
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
      dashboard.button("n", "  New file", ":ene | startinsert<CR>"),
      dashboard.button("q", "  Quit", "<cmd>qa<cr>"),
      dashboard.button("SPC o", "󰙰  Oldfiles"),
      dashboard.button("CTRL p", "󰈞  Find file"),
      dashboard.button("CTRL f", "󱎸  Find text"),
      dashboard.button("CTRL g", "  Git"),
    }

    dashboard.section.footer.val = fortune()

    alpha.setup({
      layout = {
        { type = "padding", val = 4 },
        { type = "padding", val = 1 },
        installed_plugins,
        { type = "padding", val = 2 },
        dashboard.section.buttons,
        dashboard.section.footer,
        { type = "padding", val = 2 },
        version,
      },
    })
  end,
}
