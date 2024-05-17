local M = {}

function M.current_path_in_cwd_home_escaped()
    local home_path = vim.fn.expand "$HOME"
    local current_path = vim.fn.expand "%:p"

    return current_path:gsub(home_path, "~")
end

M.current_file_path_in_cwd = function()
    return vim.fn.expand "%"
end

function M.relative_file_path()
    return vim.fn.expand "%:~:."
end

return M
