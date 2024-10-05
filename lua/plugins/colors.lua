return {
  -- "RRethy/base16-nvim",
  {
    "scottmckendry/cyberdream.nvim",
    config = function()
      require("cyberdream").setup({
        transparent = true,
        italic_comments = false,
        hide_fillchars = true,
        terminal_colors = true,
        borderless_telescope = false,
        extensions = {
          telescope = true,
          lazy = true,
          cmp = true,
        },
      })
    end,
  },
}
