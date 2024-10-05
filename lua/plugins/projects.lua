local is_neovide = vim.g.neovide ~= nil

return {
  "Rics-Dev/project-explorer.nvim",
  enabled = is_neovide,
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  opts = {
    paths = { "~/github/" }, --custom path set by user
    newProjectPath = "~/github/", --custom path for new projects
    file_explorer = function(dir)
      require("oil").open(dir)
    end,
  },
  config = function(_, opts)
    require("project_explorer").setup(opts)
  end,
  keys = {
    { "<leader>fp", "<cmd>ProjectExplorer<cr>", desc = "Project Explorer" },
  },
  lazy = false,
}
