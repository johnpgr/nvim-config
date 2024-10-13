local function lsp_status()
    local attached_clients = vim.lsp.get_clients({ bufnr = 0 })
    if #attached_clients == 0 then
        return ""
    end
    local it = vim.iter(attached_clients)
    it:map(function(client)
        local name = client.name:gsub("language.server", "ls")
        return name
    end)
    local names = it:totable()
    return table.concat(names, "  ")
end

return {
    "nvim-lualine/lualine.nvim",
    enabled = false,
    config = function()
        require("lualine").setup({
            options = {
                icons_enabled = true,
                theme = "auto",
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
                disabled_filetypes = {
                    statusline = {},
                    winbar = {},
                },
                ignore_focus = {},
                always_divide_middle = true,
                globalstatus = true,
                refresh = {
                    statusline = 1000,
                    tabline = 1000,
                    winbar = 1000,
                },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { { "filename", path = 1 } },
                lualine_c = {},
                lualine_x = { lsp_status, "encoding", "filetype" },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
            tabline = {},
            winbar = {},
            inactive_winbar = {},
            extensions = {},
        })
    end,
}
