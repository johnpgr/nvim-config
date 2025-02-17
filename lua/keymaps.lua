local utils = require("utils")
local keymap = utils.keymap
local feedkeys = utils.feedkeys
local telescope_builtin = require("telescope.builtin")
local gitsigns = require("gitsigns")
local tmux = require("tmux")
local is_neovide = utils.is_neovide

--#region Telescope
keymap("<leader>ff", telescope_builtin.find_files, "Find files")
keymap("<C-p>", telescope_builtin.find_files, "Find files")
keymap("<leader>fw", telescope_builtin.live_grep, "Find word")
keymap("<C-S-f>", telescope_builtin.live_grep, "Find word")
keymap("<leader>fo", telescope_builtin.oldfiles, "Find oldfiles")
keymap("<leader><space>", telescope_builtin.buffers, "Find open buffers")
keymap("<leader>fs", telescope_builtin.spell_suggest, "Find Spell suggestions")
keymap("<leader>fh", telescope_builtin.help_tags, "Find help tags")
keymap("<leader>fr", telescope_builtin.resume, "Resume last finder")
keymap("<leader>fc", function()
    require("telescope.builtin").colorscheme({ enable_preview = true })
end, "Find Colorscheme")

if is_neovide then
    keymap("<A-s>", require("telescope").extensions.projects.projects, "Find Projects")
end
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
keymap("<leader>o", "<cmd>Outline<CR>", "Toggle Outline view")
keymap("<leader>bd", "<cmd>bd<CR>", "Buffer delete")
--#endregion

--#region LSP
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
keymap("K", utils.smart_hover, "LSP: Hover", "n")
keymap("gd", function()
    if utils.up_jump_to_error_loc() then
        return
    else
        vim.lsp.buf.definition()
    end
end, "LSP: Goto definition", "n")
keymap("gD", vim.lsp.buf.type_definition, "LSP: Goto type definition", "n")
keymap("gr", vim.lsp.buf.references, "LSP: Goto references", "n")
keymap({ "<F2>", "<leader>lr" }, vim.lsp.buf.rename, "LSP: Rename variable", "n")
keymap("<leader>la", vim.lsp.buf.code_action, "LSP: Code actions")
keymap("<leader>ls", vim.lsp.buf.signature_help, "LSP: Signature help")
keymap("<C-s>", vim.lsp.buf.signature_help, "LSP: Signature help", "i")
keymap({ "<A-F>", "<leader>lf" }, format_buffer, "LSP: Format buffer")
keymap("<leader>ld", vim.diagnostic.setqflist, "LSP: Diagnostics List", "n")
--#endregion

--#region Tabs/Terminal
keymap("<leader>tt", "<cmd>tabnew<cr><cmd>term<cr>", "Open terminal in a new tab")
keymap("<leader>tn", "<cmd>tabnew<cr>", "Open new tab")
keymap("<leader>q", "<cmd>tabclose<cr>", "Tab close")
-- Open new tab in neovim config directory
keymap("<leader>nc", function()
    vim.cmd("tabnew")
    vim.cmd("cd " .. vim.fn.stdpath("config"))
    vim.cmd("Oil")
end, "Open new tab in neovim config directory")
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
local chat = require("CopilotChat")
local chat_select = require("CopilotChat.select")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local function parse_history_path(file)
    return vim.fn.fnamemodify(file, ":t:r")
end

local function format_display_name(filename)
    filename = filename:gsub("%.%w+$", "")
    return filename:gsub("%-", " "):gsub("^%w", string.upper)
end

local function find_chat_history()
    telescope_builtin.find_files({
        prompt_title = "Chat History",
        cwd = chat.config.history_path,
        hidden = true,
        follow = true,
        layout_config = {
            width = { padding = 35 },
        },
        find_command = { "rg", "--files", "--sortr=modified" },
        entry_maker = function(entry)
            local full_path = chat.config.history_path .. "/" .. entry
            local stat = vim.loop.fs_stat(full_path)
            local mtime = stat and stat.mtime.sec or 0
            local display_time = stat and os.date("%d-%m-%Y %H:%M", mtime) or "Unknown"
            local display_name = format_display_name(entry)
            return {
                value = entry,
                display = string.format("%s | %s", display_time, display_name),
                ordinal = string.format("%s %s", display_time, display_name),
                path = entry,
                index = -mtime,
            }
        end,
        attach_mappings = function(prompt_bufnr, _)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                local path = selection.value
                local parsed = parse_history_path(path)
                vim.g.chat_title = parsed
                chat.load(parsed)
                chat.open()
            end)
            return true
        end,
    })
end

-- local function find_chat_history()
--     telescope_builtin.find_files({
--         prompt_title = "Chat History",
--         cwd = chat.config.history_path,
--         hidden = true,
--         follow = true,
--         entry_maker = function(entry)
--             return {
--                 value = entry,
--                 display = format_display_name(entry),
--                 ordinal = entry,
--                 path = entry,
--             }
--         end,
--         attach_mappings = function(prompt_bufnr, _)
--             actions.select_default:replace(function()
--                 actions.close(prompt_bufnr)
--                 local selection = action_state.get_selected_entry()
--                 local path = selection.value
--                 local parsed = parse_history_path(path)
--                 vim.g.chat_title = parsed
--                 chat.load(parsed)
--                 chat.open()
--             end)
--             return true
--         end,
--     })
-- end

keymap("<leader>ch", find_chat_history, "CopilotChat History")
keymap("<leader>cc", "<cmd>CopilotChatToggle<cr>", "CopilotChat Toggle")
keymap("<leader>cp", function()
    local chat_actions = require("CopilotChat.actions")
    require("CopilotChat.integrations.telescope").pick(chat_actions.prompt_actions())
end, "CopilotChat Prompts")
keymap("<leader>ca", function()
    local input = vim.fn.input("Ask Copilot: ")
    if input ~= "" then
        chat.ask(input, { selection = chat_select.visual })
    end
end, "CopilotChat Ask", { "n", "v" })
keymap("<leader>cx", function()
    vim.g.chat_title = nil
    chat.reset()
end, "CopilotChat Reset")
--#endregion

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
keymap("<leader>gs", gitsigns.stage_hunk, "Hunk Stage", { "n", "v" })
keymap("<leader>gr", gitsigns.reset_hunk, "Hunk Reset")
keymap("<leader>gu", gitsigns.undo_stage_hunk, "Hunk Undo Stage")
keymap("<leader>gb", gitsigns.toggle_current_line_blame, "Toggle Blame inline")
keymap("<leader>gp", gitsigns.preview_hunk, "Hunk Preview")
keymap("<leader>gd", gitsigns.toggle_deleted, "Toggle Deleted")
keymap("<leader>gw", gitsigns.toggle_word_diff, "Toggle Word diff")
keymap("<A-S-d>", toggle_diffview, "Toggle DiffView")
keymap("ih", ":<C-U>Gitsigns select_hunk<CR>", { silent = true }, { "o", "x" })
keymap("ah", ":<C-U>Gitsigns select_hunk<CR>", { silent = true }, { "o", "x" })
keymap("<leader>gg", function()
    require("neogit").open({ kind = "replace" })
end, "Neogit")
--#endregion

--#region DAP
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
keymap("<S-A-t>", "<cmd>OverseerToggle<cr>", "Task view")
keymap("<S-A-r>", "<cmd>OverseerRun<cr>", "Task Run")
keymap("<A-r>", "<cmd>OverseerQuickAction restart<cr>", "Task Restart")
--#endregion

string.remove_start = function(str, substr)
    if str:sub(1, #substr) == substr then
        return str:sub(#substr + 1), true
    end
    return str, false
end

local SLASH = utils.is_windows and "\\" or "/"

local function unixtow32path(path)
    -- Replace forward slashes with backslashes
    local win_path = path:gsub("/", "\\")
    -- Remove leading backslash if present
    return win_path:gsub("^\\(%a)\\", "%1:\\")
end

local function find_files()
    local current_path = ""
    local changed = false

    if vim.fn.expand("%:p") ~= "" then
        current_path = vim.fn.expand("%:p")
        current_path, changed = current_path:remove_start("oil://")

        -- If it was an oil buffer, the ending / is already there.
        if changed then
            if utils.is_windows then
                current_path = unixtow32path(current_path)
            end
        else
            -- If it's a directory, ensure it ends with /
            if vim.fn.isdirectory(current_path) == 1 then
                current_path = current_path .. SLASH
            else
                current_path = vim.fn.fnamemodify(current_path, ":h") .. SLASH
            end
        end
    end
    feedkeys(":e " .. current_path)
end

keymap("<C-e>", find_files, "Find files")
keymap("<A-x>", utils.show_keymaps, "Show keymaps")
keymap("<leader>tc", "<cmd>TextCaseOpenTelescope<cr>", "Textcase convert", { "n", "v" })
