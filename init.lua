local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latst stable release
        lazypath,
    })
end
vim.opt.runtimepath:prepend(lazypath)

require("options")
require("lazy").setup({
    rocks = {
        hererocks = true,
    },
    spec = "plugins"
})
require("highlights")
require("keymaps")
require("cmds")
require("utils").load_colorscheme()
