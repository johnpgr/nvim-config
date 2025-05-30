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

require "options"
require "lazy".setup("plugins")
require "keymaps"
require "cmds"
require "utils".load_colorscheme()
require "highlights"
require "snippets"

vim.g["conjure#mapping#enable_defaults"] = false
vim.g["conjure#mapping#eval_current_form"] = "E"
vim.g["conjure#mapping#eval_visual"] = "E"
vim.g["conjure#mapping#eval_buf"] = "!"
vim.g["conjure#mapping#log_vsplit"] = "L"
