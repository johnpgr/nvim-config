local term = os.getenv("TERM")
local kitty = term == "xterm-kitty"

return {
    "NeogitOrg/neogit",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    cmd = "Neogit",
    opts = {
        graph_style = kitty and "kitty" or "ascii",
        commit_editor = {
            kind = "vsplit",
            show_staged_diff = false,
        },
        console_timeout = 5000,
        auto_show_console = false,
    },
}
