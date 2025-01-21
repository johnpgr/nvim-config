local utils = require("utils")

local function set_colors(colorscheme)
    local previous_theme = vim.g.colors_name or "default"
    local ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
    if not ok then
        print("Error: Failed to load colorscheme: " .. colorscheme)
        pcall(vim.cmd, "colorscheme " .. previous_theme)
        return false
    end

    -- Get config path and create colorscheme.lua path
    local config_path = vim.fn.stdpath("config")
    local colorscheme_file = config_path .. "/lua/colorscheme.lua"

    -- Create the content to write
    local content = string.format('vim.cmd("colorscheme %s")', colorscheme)

    -- Write to file
    local file = io.open(colorscheme_file, "w")
    if file then
        file:write(content)
        file:close()
    else
        print("Error: Could not write to " .. colorscheme_file)
    end

    vim.g.current_theme = colorscheme
    return true
end

local function show_colorscheme_picker()
    local available_colorschemes = vim.fn.getcompletion("", "color")
    local colorschemes = {}
    for _, colorscheme in ipairs(available_colorschemes) do
        table.insert(colorschemes, colorscheme)
    end
    local qf_entries = {}
    for _, scheme in ipairs(colorschemes) do
        table.insert(qf_entries, {
            text = scheme,
            bufnr = 0,
            nr = 0,
        })
    end
    vim.fn.setqflist(qf_entries)
    vim.cmd("copen")
    vim.keymap.set("n", "<CR>", function()
        local current_line = vim.fn.line(".")
        local colorscheme = vim.fn.getqflist()[current_line].text
        set_colors(colorscheme)
    end, { buffer = true, noremap = true, silent = true })
end

utils.keymap("<leader>cs", show_colorscheme_picker, "show_colorscheme_picker")

return {
    "morhetz/gruvbox",
    "sainnhe/gruvbox-material",
    { "aliqyan-21/darkvoid.nvim" },
    {
        "rebelot/kanagawa.nvim",
        opts = { compile = true, commentStyle = { italic = false }, keywordStyle = { italic = false } },
    },
    { "water-sucks/darkrose.nvim" },
    { "folke/tokyonight.nvim", opts = {} },
    { "catppuccin/nvim", name = "catppuccin" },
    { "miikanissi/modus-themes.nvim", priority = 1000 },
    { "felipeagc/fleet-theme-nvim" },
}
