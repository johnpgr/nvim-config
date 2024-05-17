local M = {}

function M.toggle_spaces_width()
    local currentWidth = vim.opt.shiftwidth:get()
    local currentTabstop = vim.opt.tabstop:get()

    if currentWidth == 2 and currentTabstop == 2 then
        vim.opt.shiftwidth = 4
        vim.opt.tabstop = 4
    else
        vim.opt.shiftwidth = 2
        vim.opt.tabstop = 2
    end
    -- Print a message to indicate the current values
    print("Shiftwidth: " .. vim.opt.shiftwidth:get() .. " Tabstop: " .. vim.opt.tabstop:get())
end

function M.toggle_tabs_and_spaces()
    -- Get the current buffer number
    local bufnr = vim.fn.bufnr()

    -- Get the current value of 'expandtab' (whether spaces are being used)
    local expandtab = vim.bo.expandtab

    if expandtab then
        -- If spaces are being used, toggle to tabs
        vim.bo.expandtab = false
    else
        -- If tabs are being used, toggle to spaces
        vim.bo.expandtab = true
    end

    -- Get the updated values of 'tabstop' and 'shiftwidth' after toggling
    local tabstop = vim.bo.tabstop
    local shiftwidth = vim.bo.shiftwidth

    -- Retab the buffer to apply the changes
    vim.fn.execute('retab!')

    -- Display a message indicating the toggle is done
    local current_mode = vim.bo.expandtab == true and "Spaces" or "Tabs"
    print("Current indentation mode: " .. current_mode)
end

return M
