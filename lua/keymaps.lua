_G.COPILOT_ENABLED = true
local utils = require("utils")
local keymap = utils.keymap
local feedkeys = utils.feedkeys
local which_key = require("which-key")

local telescope = require("telescope-utils")
local telescope_builtin = require("telescope.builtin")
local gitsigns = require("gitsigns")
local tmux = require("tmux")

--#region Telescope
which_key.add({ { "<leader>f", group = "Find" } })
keymap("<C-p>", telescope.list_files_cwd, "Find files")
keymap("<C-f>", telescope.live_grep, "Find word")
keymap("<C-e>", telescope.list_recent_files, "Find oldfiles")
keymap("<leader>ff", telescope.list_files_cwd, "Find files")
keymap("<leader>fw", telescope.live_grep, "Find word")
keymap("<leader>fo", telescope.list_recent_files, "Find oldfiles")
keymap("<leader><space>", telescope_builtin.buffers, "Find open buffers")
keymap("<leader>fb", telescope_builtin.buffers, "Find open buffers")
keymap("<leader>fs", telescope.list_spell_suggestions_under_cursor, "Find Spell suggestions")
keymap("<leader>fh", telescope_builtin.help_tags, "Find help tags")
keymap("<leader>fr", telescope_builtin.resume, "Resume last finder")
keymap("<leader>fc", function()
    require("telescope.builtin").colorscheme({ enable_preview = true })
end, "Find Colorscheme")
--#endregion

--#region General
keymap("<leader>ts", utils.toggle_spaces_width, "Toggle shift width")
keymap("<leader>ti", utils.toggle_indent_mode, "Toggle indentation mode")
keymap("<C-_>", "gcc", { remap = true, silent = true, desc = "Comment toggle" }, "n")
keymap("<C-_>", "gc", { remap = true, silent = true, desc = "Comment toggle" }, "v")
keymap("<C-/>", "gcc", { remap = true, silent = true, desc = "Comment toggle" }, "n")
keymap("<C-/>", "gc", { remap = true, silent = true, desc = "Comment toggle" }, "v")
keymap("<leader>e", "<cmd>Oil<cr>", "Explorer")
keymap("<leader>L", "<cmd>Lazy<cr>", "Lazy.nvim")
keymap("<C-k>", tmux.move_top, "Focus top split")
keymap("<C-l>", tmux.move_right, "Focus right split")
keymap("<C-j>", tmux.move_bottom, "Focus bottom split")
keymap("<C-h>", tmux.move_left, "Focus left split")
keymap("<A-k>", tmux.resize_top, "Focus top split")
keymap("<A-l>", tmux.resize_right, "Focus right split")
keymap("<A-j>", tmux.resize_bottom, "Focus bottom split")
keymap("<A-h>", tmux.resize_left, "Focus left split")
keymap("<A-=>", "<C-w>=", "Reset splits sizes")
keymap("<leader>v", "<cmd>vsp<cr><C-w>l", "New vertical split")
keymap("<leader>V", "<cmd>bo vsp<cr>", "New vertical split")
keymap("<leader>h", "<cmd>sp<cr>", "New horizontal split")
keymap("<leader>H", "<cmd>bo sp<cr>", "New horizontal split")
keymap("<Esc>", "<cmd>noh<cr>", "Clear search highlights", "n")
keymap("n", "nzz", "Better jump next", "n")
keymap("]d", function()
    vim.diagnostic.goto_next()
    feedkeys("zz")
end, { desc = "Better jump next diagnostic", remap = true }, "n")
keymap("[d", function()
    vim.diagnostic.goto_prev()
    feedkeys("zz")
end, { desc = "Better jump prev diagnostic", remap = true }, "n")
keymap("J", ":m '>+1<CR>gv=gv", "Move line down", "v")
keymap("K", ":m '<-2<CR>gv=gv", "Move line up", "v")
keymap("<", "<gv", "Keep selection when indenting multiple lines", "v")
keymap(">", ">gv", "Keep selection when indenting multiple lines", "v")
keymap("J", ":m '>+1<CR>gv=gv", "Move line down", "v")
keymap("K", ":m '<-2<CR>gv=gv", "Move line up", "v")
keymap("<leader>i", "<cmd>Inspect<cr>", "Inspect")
keymap("<leader>zm", "<cmd>ZenMode<cr>", "Zen mode")
keymap("<leader>st", function()
    ---@diagnostic disable-next-line: undefined-field
    vim.opt.spell = not vim.opt.spell:get()
end, "Toggle spellchecking")
keymap("yig", ":%y<CR>", "Yank buffer", "n")
keymap("vig", "ggVG", "Visual select buffer", "n")
keymap("cig", ":%d<CR>i", "Change buffer", "n")
--#endregion

--#region LSP
which_key.add({ { "<leader>l", group = "LSP" } })

local function format_buffer()
    require("conform").format({
        async = true,
        stop_after_first = true,
        lsp_format = "fallback",
    })
end

keymap("<space>x", function()
    for _, client in ipairs(vim.lsp.buf_get_clients()) do
        print("client: ", client.name)
        require("workspace-diagnostics").populate_workspace_diagnostics(client, 0)
    end
end, "LSP: Refresh diagnostics")

local floating_highlight_map = {
    [vim.diagnostic.severity.ERROR] = "DiagnosticFloatingError",
    [vim.diagnostic.severity.WARN] = "DiagnosticFloatingWarn",
    [vim.diagnostic.severity.INFO] = "DiagnosticFloatingInfo",
    [vim.diagnostic.severity.HINT] = "DiagnosticFloatingHint",
}

local function smart_hover()
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

    vim.lsp.buf_request(0, "textDocument/hover", hover_params, function(_, result)
        if not result or not result.contents then
            return
        end

        local diagnostics = vim.diagnostic.get(0, {
            lnum = row,
            col = col,
        })

        diagnostics = vim.tbl_filter(function(d)
            return d.lnum == row
                and col >= (d.col or 0)
                and col <= (d.end_col or #vim.api.nvim_buf_get_lines(0, row, row + 1, true)[1])
        end, diagnostics)

        -- Convert hover result first
        local contents = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
        -- Add padding to hover contents
        for i, line in ipairs(contents) do
            contents[i] = " " .. line .. " "
        end

        local highlights = {}

        -- Add diagnostics section if we have any
        if #diagnostics > 0 then
            table.insert(contents, " Diagnostics: ")

            -- Mark header for highlighting
            table.insert(highlights, {
                line = #contents - 1,
                hlname = "Bold",
                prefix_length = 1, -- Account for left padding
                suffix_length = 1, -- Account for right padding
                content = " Diagnostics: ",
            })

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
        end

        if #diagnostics > 0 then
            table.insert(contents, " ```") -- Margin at the end of the diagnostics
        end

        local buf, win = vim.lsp.util.open_floating_preview(contents, "markdown", {
            border = "none",
            focus = false,
        })

        -- Apply highlights for diagnostics
        for _, hl in ipairs(highlights) do
            local line_length = #hl.content

            -- Highlight prefix (number) as NormalFloat
            if hl.prefix_length > 0 then
                vim.api.nvim_buf_add_highlight(buf, -1, "NormalFloat", hl.line, 1, hl.prefix_length) -- Start at 1 to skip left padding
            end

            -- Highlight main diagnostic message
            local message_start = hl.prefix_length
            local message_end = line_length - hl.suffix_length
            vim.api.nvim_buf_add_highlight(buf, -1, hl.hlname, hl.line, message_start, message_end)

            -- Highlight suffix (code) as NormalFloat
            if hl.suffix_length > 0 then
                vim.api.nvim_buf_add_highlight(buf, -1, "NormalFloat", hl.line, message_end, line_length - 1) -- -1 to account for right padding
            end
        end

        return buf, win
    end)
end

keymap("K", smart_hover, "LSP: Hover", "n")
keymap("gd", vim.lsp.buf.definition, "LSP: Goto definition", "n")
keymap("gD", vim.lsp.buf.type_definition, "LSP: Goto type definition", "n")
keymap("gr", vim.lsp.buf.references, "LSP: Goto references", "n")
keymap({ "<F2>", "<leader>lr" }, vim.lsp.buf.rename, "LSP: Rename variable", "n")
keymap("<leader>la", vim.lsp.buf.code_action, "LSP: Code actions")
keymap("<leader>ls", vim.lsp.buf.signature_help, "LSP: Signature help")
keymap("<C-s>", vim.lsp.buf.signature_help, "LSP: Signature help", "i")
keymap("<leader>lr", "<cmd>LspRestart<cr>", "LSP: Restart language server")
keymap({ "<A-F>", "<leader>lf" }, format_buffer, "LSP: Format buffer")
keymap("<leader>ld", vim.diagnostic.setqflist, "LSP: Diagnostics List", "n")
--#endregion

--#region Tabs/Terminal
keymap("<leader>tt", "<cmd>tabnew<cr><cmd>term<cr>", "Open terminal in a new tab")
keymap("<leader>tn", "<cmd>tabnew<cr>", "Open new tab")
keymap("<Esc>", "<C-\\><C-n>", "Terminal mode easy exit", "t")
keymap("]t", "<cmd>tabnext<cr>", "Tab next")
keymap("[t", "<cmd>tabprevious<cr>", "Tab previous")
--#endregion

--#region Quickfixlist
local function toggle_qf()
    local qf_exists = false
    for _, win in pairs(vim.fn.getwininfo()) do
        if win.quickfix == 1 then
            qf_exists = true
        end
    end
    if qf_exists then
        vim.cmd.cclose()
    else
        vim.cmd.copen()
    end
end

which_key.add({ { "<leader>q", group = "Quickfix" } })
keymap("<A-q>", toggle_qf, "Quickfixlist toggle")
keymap("]q", function()
    local qf_list = vim.fn.getqflist()
    local qf_length = #qf_list
    if qf_length == 0 then
        return
    end

    local current_idx = vim.fn.getqflist({ idx = 0 }).idx
    if current_idx >= qf_length then
        vim.cmd("cfirst")
    else
        vim.cmd("cnext")
    end
    vim.cmd("copen")
end, "Quickfixlist next")

keymap("[q", function()
    local qf_list = vim.fn.getqflist()
    local qf_length = #qf_list
    if qf_length == 0 then
        return
    end

    local current_idx = vim.fn.getqflist({ idx = 0 }).idx
    if current_idx <= 1 then
        vim.cmd("clast")
    else
        vim.cmd("cprevious")
    end
    vim.cmd("copen")
end, "Quickfixlist previous")
--#endregion

--#region CopilotChat
which_key.add({ { "<leader>c", group = "Copilot" } })
keymap("<leader>ct", "<cmd>CopilotChatToggle<cr>", "Copilot Toggle")
keymap("<leader>cp", function()
    local actions = require("CopilotChat.actions")
    require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
end, "Copilot Prompts")
keymap("<leader>ca", function()
    local input = vim.fn.input("Ask Copilot: ")
    if input ~= "" then
        require("CopilotChat").ask(input, { selection = require("CopilotChat.select").visual })
    end
end, "Copilot Ask", { "n", "v" })
keymap("<leader>cc", function()
    COPILOT_ENABLED = not COPILOT_ENABLED
    require("copilot.command").toggle()
    print("Copilot completion is now " .. (COPILOT_ENABLED and "enabled" or "disabled"))
end, "Copilot Completion Toggle")
--

keymap("<leader>th", "<cmd>TSToggle highlight<cr>", "Toggle treesitter highlight")

--#region Git
local function toggle_diffview()
    local diffview = require("diffview")
    local diffview_tab_exists = false
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local buf_name = vim.api.nvim_buf_get_name(buf)
        if buf_name:match("^diffview://") then
            diffview_tab_exists = true
            break
        end
    end

    if diffview_tab_exists then
        diffview.close()
    else
        diffview.open({})
    end
end

keymap("]h", function()
    if vim.wo.diff then
        vim.cmd.normal({ "]c", bang = true })
    else
        gitsigns.nav_hunk("next")
    end
end, "Goto next hunk")
keymap("[h", function()
    if vim.wo.diff then
        vim.cmd.normal({ "[c", bang = true })
    else
        gitsigns.nav_hunk("prev")
    end
end, "Goto prev hunk")
keymap("<A-s>", gitsigns.stage_hunk, "Hunk Stage", { "n", "v" })
keymap("<A-r>", gitsigns.reset_hunk, "Hunk Reset")
keymap("<A-u>", gitsigns.undo_stage_hunk, "Hunk Undo Stage")
keymap("<A-b>", gitsigns.toggle_current_line_blame, "Toggle Blame inline")
keymap("<A-p>", gitsigns.preview_hunk, "Hunk Preview")
keymap("<A-d>", gitsigns.toggle_deleted, "Toggle Deleted")
keymap("<A-w>", gitsigns.toggle_word_diff, "Toggle Word diff")
keymap("<A-D>", toggle_diffview, "Diffview Open")
keymap("ih", ":<C-U>Gitsigns select_hunk<CR>", { silent = true }, { "o", "x" })
keymap("ah", ":<C-U>Gitsigns select_hunk<CR>", { silent = true }, { "o", "x" })
keymap("<C-g>", function()
    require("neogit").open({ kind = "replace" })
end, "Neogit")
--#endregion

--#region DAP
which_key.add({ { "<leader>d", group = "Debug" } })
keymap("<leader>dc", require("dap").continue, "Debug: Continue")
keymap("<leader>do", require("dap").step_over, "Debug: Step over")
keymap("<leader>di", require("dap").step_into, "Debug: Step into")
keymap("<leader>dO", require("dap").step_out, "Debug: Step out")
keymap("<leader>db", require("dap").toggle_breakpoint, "Debug: Toggle breakpoint")
keymap("<leader>dB", function()
    require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, "Debug: Set breakpoint condition")
keymap("<leader>du", function()
    require("dapui").toggle({ reset = true })
end, "Toggle DAP UI")
keymap("<leader>db", require("dap").list_breakpoints, "DAP Breakpoints")
keymap("<leader>ds", function()
    local widgets = require("dap.ui.widgets")
    local view = widgets.centered_float(widgets.scopes, { border = "none" })

    vim.api.nvim_buf_set_keymap(view.buf, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(view.buf, "n", "<Esc>", "<cmd>close<CR>", { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(view.buf, "n", "<C-c>", "<cmd>close<CR>", { noremap = true, silent = true })
end, "DAP Scopes")
keymap("<F1>", function()
    local widgets = require("dap.ui.widgets")
    local view = widgets.hover(nil, { border = "none" })

    vim.api.nvim_buf_set_keymap(view.buf, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(view.buf, "n", "<Esc>", "<cmd>close<CR>", { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(view.buf, "n", "<C-c>", "<cmd>close<CR>", { noremap = true, silent = true })
end, "DAP Hover")
keymap("<F4>", "<CMD>DapTerminate<CR>", "DAP Terminate")
keymap("<F5>", "<CMD>DapContinue<CR>", "DAP Continue")
keymap("<F6>", function()
    require("dap").run_to_cursor()
end, "Run to Cursor")
keymap("<F9>", "<CMD>DapToggleBreakpoint<CR>", "Toggle Breakpoint")
keymap("<F10>", "<CMD>DapStepOver<CR>", "Step Over")
keymap("<F11>", "<CMD>DapStepInto<CR>", "Step Into")
keymap("<F12>", "<CMD>DapStepOut<CR>", "Step Out")
keymap("<F17>", function()
    require("dap").run_last()
end, "Run Last")
keymap("<F21>", function()
    vim.ui.input({ prompt = "Breakpoint condition: " }, function(input)
        require("dap").set_breakpoint(input)
    end)
end, "Conditional Breakpoint")

--#region Overseer
which_key.add({ { "<leader>t", group = "Tasks" } })
keymap("<leader>tl", "<cmd>OverseerToggle<cr>", "Task List")
keymap("<leader>tr", "<cmd>OverseerRun<cr>", "Task Run")
--#endregion
