---@diagnostic disable: undefined-field, deprecated
return {
    "nvim-lualine/lualine.nvim",
    config = function()
        local path_utils = require "utils.file-path"
        local harpoon = require "harpoon"

        local function string_includes(str, substr) return string.find(str, substr, 1, true) ~= nil end

        local function ignored_filetypes(current_filetype)
            local ignore = {
                "oil",
                "toggleterm",
                "alpha",
                "harpoon",
                "TelescopePrompt",
            }

            if vim.tbl_contains(ignore, current_filetype) then return true end

            return false
        end

        local function harpoon_component()
            if ignored_filetypes(vim.bo.filetype) then return "" end

            local total_marks = harpoon:list():length()
            if total_marks == 0 then return "" end

            local current_mark_name = path_utils.current_file_path_in_cwd()
            local current_mark_index = -1

            for index, mark in ipairs(harpoon:list().items) do
                if string_includes(current_mark_name, mark.value) then current_mark_index = index end
            end

            if current_mark_index == -1 then return string.format("%s/%d", "-", total_marks) end

            return string.format("%d/%d", current_mark_index, total_marks)
        end

        local function current_indentation()
            if ignored_filetypes(vim.bo.filetype) then return "" end

            local current_indent = vim.bo.expandtab and "spaces" or "tab size"

            local indent_size = -1

            if current_indent == "spaces" then
                indent_size = vim.bo.shiftwidth
            else
                indent_size = vim.bo.tabstop
            end

            return current_indent .. ": " .. indent_size
        end

        local function fileformat()
            if ignored_filetypes(vim.bo.filetype) then return "" end

            local format = vim.bo.fileformat

            if format == "unix" then
                return "lf"
            elseif format == "dos" then
                return "crlf"
            else
                return "cr"
            end
        end

        require("lualine").setup {
            options = {
                theme = "auto",
                globalstatus = true,
                icons_enabled = true,
                component_separators = {
                    left = "",
                    right = "",
                },
                section_separators = {
                    left = "",
                    right = "",
                },
            },
            sections = {
                lualine_a = {
                    "mode",
                },
                lualine_b = { "branch", "diff", "diagnostics" },
                lualine_c = {
                    harpoon_component,
                    {
                        "filename",
                        path = 1,
                    },
                },
                lualine_x = {
                    {
                        require("noice").api.statusline.mode.get,
                        cond = require("noice").api.statusline.mode.has,
                        color = { fg = "#ff9e64" },
                    },
                    "filetype",
                },
                lualine_y = { "encoding", fileformat, current_indentation },
                lualine_z = { "location" },
            },
        }
    end,
}
