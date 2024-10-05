return {
  -- "RRethy/base16-nvim",
  {
    "scottmckendry/cyberdream.nvim",
    config = function()
      require("cyberdream").setup({
        transparent = true,
        italic_comments = false,
        hide_fillchars = false,
        borderless_telescope = false,
        extensions = {
          treesittercontext = false,
        },
      })
    end,
  },
}
