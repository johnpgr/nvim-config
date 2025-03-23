local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
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
require("lazy").setup("plugins")
require("colorscheme")
require("hl")
require("keymaps")
require("statusline")
require("cmds")

vim.keymap.set('n', '<leader>m', function()
    vim.cmd('redir @a | silent messages | redir END | new | put a')
end, { desc = 'Open messages in buffer' })
