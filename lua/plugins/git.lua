return {
    "NeogitOrg/neogit",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    cmd = "Neogit",
    opts = {
        graph_style = "unicode",
        commit_editor = {
            kind = "vsplit",
            show_staged_diff = false,
        },
        console_timeout = 5000,
        auto_show_console = false,
    },
}
