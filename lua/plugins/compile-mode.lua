return {
	"ej-shafran/compile-mode.nvim",
	version = "^5.0.0",
    cmd = { "Compile" },
	branch = "nightly",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "m00qek/baleia.nvim", tag = "v1.3.0" },
	},
    config = function()
        vim.g.compile_mode = {
            baleia_setup = true,
            bang_expansion = true,
        }
    end,
}
