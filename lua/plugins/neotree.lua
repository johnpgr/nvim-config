return {
	"nvim-neo-tree/neo-tree.nvim",
    enabled = false,
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		-- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
	},
	lazy = false, -- neo-tree will lazily load itself
	---@module "neo-tree"
	---@type neotree.Config?
	opts = {
        window = {
            width = 30,
        },
        filesystem = {
            follow_current_file = {
                enabled = true,
            },
        }
	},
}
