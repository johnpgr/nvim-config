local M = {}

M.nerd_icons = true
M.is_neovide = vim.g.neovide ~= nil
M.is_windows = vim.fn.has("win32") == 1

function M.lua_ls_on_init(client)
    local path = vim.tbl_get(client, "workspace_folders", 1, "name")
    if not path then
        vim.print("no workspace")
        return
    end
    client.settings = vim.tbl_deep_extend("force", client.settings, {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                    -- Depending on the usage, you might want to add additional paths here.
                    -- "${3rd}/luv/library"
                    -- "${3rd}/busted/library",
                },
                -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                -- library = vim.api.nvim_get_runtime_file("", true)
            },
        },
    })
end

M.keymap_registry = {}

---Utility for keymap creation.
---@param lhs string|string[]
---@param rhs string|function
---@param opts string|table
---@param mode? string|string[]
function M.keymap(lhs, rhs, opts, mode)
    opts = type(opts) == "string" and { desc = opts }
        or vim.tbl_extend("error", opts --[[@as table]], { buffer = bufnr })
    mode = mode or { "n", "v" }

    if type(lhs) == "table" then
        for _, l in ipairs(lhs) do
            vim.keymap.set(mode, l, rhs, opts)
            table.insert(M.keymap_registry, {
                key = l,
                rhs = rhs,
                modes = mode,
                description = opts.desc or "No description",
            })
        end
    else
        vim.keymap.set(mode, lhs, rhs, opts)
        table.insert(M.keymap_registry, {
            key = lhs,
            rhs = rhs,
            modes = mode,
            description = opts.desc or "No description",
        })
    end
end

---For replacing certain <C-x>... keymaps.
---@param keys string
function M.feedkeys(keys)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "n", true)
end

function M.show_keymaps()
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local dropdown = require("telescope.themes").get_dropdown

    pickers.new({}, dropdown({
                prompt_title = "Keymaps",
                finder = finders.new_table({
                    results = M.keymap_registry,
                    entry_maker = function(entry)
                        local modes = type(entry.modes) == "table" and table.concat(entry.modes, ", ") or entry.modes

                        return {
                            value = entry,
                            display = string.format("%s ➜ %s {%s}", entry.key, entry.description, modes),
                            ordinal = entry.key .. entry.description,
                        }
                    end,
                }),
                sorter = conf.generic_sorter({}),
                attach_mappings = function(bufnr, map)
                    actions.select_default:replace(function()
                        local selection = action_state.get_selected_entry()
                        local value = selection.value

                        actions.close(bufnr)

                        if type(value.rhs) == "function" then
                            value.rhs()
                        else
                            M.feedkeys(value.key)
                        end
                    end)
                    return true
                end,
            })):find()
end

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

function M.toggle_indent_mode()
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
    vim.fn.execute("retab!")

    -- Display a message indicating the toggle is done
    local current_mode = vim.bo.expandtab == true and "Spaces" or "Tabs"
    print("Current indentation mode: " .. current_mode)
end

local floating_highlight_map = {
    [vim.diagnostic.severity.ERROR] = "DiagnosticFloatingError",
    [vim.diagnostic.severity.WARN] = "DiagnosticFloatingWarn",
    [vim.diagnostic.severity.INFO] = "DiagnosticFloatingInfo",
    [vim.diagnostic.severity.HINT] = "DiagnosticFloatingHint",
}

function M.smart_hover()
    -- Check if there's already a hover window open
    local hover_win = nil
    for _, win in pairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_config(win).relative == "win" then
            hover_win = win
            if vim.api.nvim_win_is_valid(hover_win) then
                vim.api.nvim_set_current_win(hover_win)
                return
            end
        end
    end

    local hover_params = vim.lsp.util.make_position_params()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    row = row - 1

    local function show_window(contents, highlights)
        local buf, win = vim.lsp.util.open_floating_preview(contents, "markdown", {
            border = "none",
            focus = false,
        })

        -- Find where the diagnostic section starts
        local diagnostic_start = 0
        for i, line in ipairs(contents) do
            if line == " Diagnostics: " then
                diagnostic_start = i - 1
                break
            end
        end

        -- Apply highlights for diagnostics with adjusted line numbers
        for _, hl in ipairs(highlights or {}) do
            local line_length = #hl.content
            if diagnostic_start > 0 then
                hl.line = hl.line + diagnostic_start
            end

            if hl.prefix_length > 0 then
                vim.api.nvim_buf_add_highlight(buf, -1, "NormalFloat", hl.line, 1, hl.prefix_length)
            end

            local message_start = hl.prefix_length
            local message_end = line_length - hl.suffix_length
            vim.api.nvim_buf_add_highlight(buf, -1, hl.hlname, hl.line, message_start, message_end)

            if hl.suffix_length > 0 then
                vim.api.nvim_buf_add_highlight(buf, -1, "NormalFloat", hl.line, message_end, line_length)
            end
        end

        return buf, win
    end

    local function get_diagnostics_content()
        local diagnostics = vim.diagnostic.get(0, {
            lnum = row,
            col = col,
        })

        diagnostics = vim.tbl_filter(function(d)
            return d.lnum == row
                and col >= (d.col or 0)
                and col <= (d.end_col or #vim.api.nvim_buf_get_lines(0, row, row + 1, true)[1])
        end, diagnostics)

        if #diagnostics == 0 then
            return nil, nil
        end

        local contents = { " Diagnostics: " }
        local highlights = {
            {
                line = 0,
                hlname = "Bold",
                prefix_length = 1,
                suffix_length = 1,
                content = " Diagnostics: ",
            },
        }

        for i, diagnostic in ipairs(diagnostics) do
            local prefix = string.format("%d. ", i)
            local suffix = diagnostic.code and string.format(" [%s]", diagnostic.code) or ""
            local message_lines = vim.split(diagnostic.message, "\n")

            for j = 1, #message_lines do
                local pre = j == 1 and prefix or string.rep(" ", #prefix)
                local suf = j == #message_lines and suffix or ""
                local line = " " .. pre .. message_lines[j] .. suf .. " "
                table.insert(contents, line)
                table.insert(highlights, {
                    line = #contents - 1,
                    hlname = floating_highlight_map[diagnostic.severity],
                    prefix_length = #pre + 1,
                    suffix_length = #suf + 1,
                    content = line,
                })
            end
        end
        return contents, highlights
    end

    vim.lsp.buf_request(0, "textDocument/hover", hover_params, function(_, result)
        local contents = {}
        local highlights = {}

        -- Add hover content if available
        if result and result.contents then
            local hover_contents = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
            for _, line in ipairs(hover_contents) do
                table.insert(contents, " " .. line .. " ")
            end
        end

        -- Get diagnostics content
        local diag_contents, diag_highlights = get_diagnostics_content()
        -- If we have either hover content or diagnostics, show the window
        if (#contents > 0 and result) or diag_contents then
            local diagnostic_start = 0
            if diag_contents then
                vim.list_extend(contents, diag_contents)
                vim.list_extend(highlights, diag_highlights)
            end
            show_window(contents, highlights)
        end
    end)
end

function M.up_jump_to_error_loc()
    local line = vim.fn.getline(".")
    local file, lnum, col = string.match(line, "([^:]+):(%d+):(%d+):")

    if not (file and lnum and col) then
        vim.notify("No file:line:column pattern found in current line", vim.log.levels.WARN)
        return
    end

    if vim.fn.filereadable(file) ~= 1 then
        vim.notify("File not found: " .. file, vim.log.levels.ERROR)
        return
    end

    lnum = tonumber(lnum)
    col = tonumber(col)

    -- Find if the file is already open in a buffer
    local bufnr = vim.fn.bufnr(vim.fn.fnamemodify(file, ":p"))
    local win_id = nil

    -- Check if buffer is visible in any window
    if bufnr ~= -1 then
        local wins = vim.fn.getbufinfo(bufnr)[1].windows
        if #wins > 0 then
            win_id = wins[1]
        end
    end

    if win_id then
        -- If buffer is visible, switch to its window
        vim.fn.win_gotoid(win_id)
    else
        -- Check for window above current window
        local window_above = vim.fn.winnr("#")

        if window_above ~= 0 then
            -- Go to window above
            vim.cmd("wincmd k")
            -- Open file in this window
            vim.cmd("edit " .. file)
        else
            -- If no window above, create new split
            vim.cmd("topleft split " .. file)
        end
    end

    -- Move cursor to error position
    vim.api.nvim_win_set_cursor(0, { lnum, col - 1 })

    -- Center the screen on the error
    vim.cmd("normal! zz")
end

function M.left_jump_to_error_loc()
    local line = vim.fn.getline(".")
    -- First remove the Unicode symbol and any leading spaces
    line = line:gsub("^[^./a-zA-Z0-9]+", "")
    -- Remove any remaining leading whitespace
    line = line:gsub("^%s+", "")

    local file, lnum, col = string.match(line, "([^:]+):(%d+):(%d+)")

    if not (file and lnum and col) then
        vim.notify("No file:line:column pattern found in current line", vim.log.levels.WARN)
        return
    end

    if vim.fn.filereadable(file) ~= 1 then
        vim.notify("File not found: " .. file, vim.log.levels.ERROR)
        return
    end

    lnum = tonumber(lnum)
    col = tonumber(col)

    -- Find if the file is already open in a buffer
    local bufnr = vim.fn.bufnr(vim.fn.fnamemodify(file, ":p"))
    local win_id = nil

    -- Check if buffer is visible in any window
    if bufnr ~= -1 then
        local wins = vim.fn.getbufinfo(bufnr)[1].windows
        if #wins > 0 then
            win_id = wins[1]
        end
    end

    if win_id then
        -- If buffer is visible, switch to its window
        vim.fn.win_gotoid(win_id)
    else
        -- Check for window to the left of current window
        local current_winnr = vim.fn.winnr()
        vim.cmd("wincmd h")
        local window_left = vim.fn.winnr()
        -- Go back to original window
        vim.cmd(current_winnr .. "wincmd w")

        if window_left ~= current_winnr then
            -- Go to window on the left
            vim.cmd("wincmd h")
            -- Open file in this window
            vim.cmd("edit " .. file)
        else
            -- If no window on the left, create new vsplit
            vim.cmd("topleft vsplit " .. file)
        end
    end

    -- Move cursor to error position
    vim.api.nvim_win_set_cursor(0, { lnum, col - 1 })

    -- Center the screen on the error
    vim.cmd("normal! zz")
end

return M
