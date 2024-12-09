local utils = require("utils")
local keymap = utils.keymap
local feedkeys = utils.feedkeys

local telescope = require("telescope-utils")
local telescope_builtin = require("telescope.builtin")
local gitsigns = require("gitsigns")
local tmux = require("tmux")

--#region Telescope
keymap("<C-p>", telescope.list_files_cwd, "Find files")
keymap("<C-f>", telescope.live_grep, "Find word")
keymap("<C-e>", telescope.list_recent_files, "Find oldfiles")
keymap("<leader><space>", telescope_builtin.buffers, "Find open buffers")
keymap("<leader>fs", telescope.list_spell_suggestions_under_cursor, "Find Spell suggestions")
keymap("<leader>fh", telescope_builtin.help_tags, "Find help tags")
keymap("<leader>fr", telescope_builtin.resume, "Resume last finder")
--

keymap("<leader>ts", utils.toggle_spaces_width, "Toggle shift width")
keymap("<leader>ti", utils.toggle_indent_mode, "Toggle indentation mode")
keymap("<C-_>", "gcc", { remap = true, silent = true, desc = "Comment toggle" }, "n")
keymap("<C-_>", "gc", { remap = true, silent = true, desc = "Comment toggle" }, "v")
keymap("<C-/>", "gcc", { remap = true, silent = true, desc = "Comment toggle" }, "n")
keymap("<C-/>", "gc", { remap = true, silent = true, desc = "Comment toggle" }, "v")
keymap("<leader>e", "<cmd>Oil<cr>", "Explorer")
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
-- keymap("<C-d>", "<C-d>zz", "Better scroll down")
-- keymap("<C-u>", "<C-u>zz", "Better scroll up")
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
keymap("gd", vim.lsp.buf.definition, "LSP: Goto definition", "n")
keymap("gD", vim.lsp.buf.type_definition, "LSP: Goto type definition", "n")
keymap("gr", vim.lsp.buf.references, "LSP: Goto references", "n")
keymap("<leader>ld", vim.diagnostic.setqflist, "LSP: Send diagnostics to quickfix", "n")
keymap("<leader>lr", vim.lsp.buf.rename, "LSP: Rename variable", "n")
keymap("<leader>la", vim.lsp.buf.code_action, "LSP: Code actions")
keymap("<leader>ls", vim.lsp.buf.signature_help, "LSP: Signature help")
keymap("<C-s>", vim.lsp.buf.signature_help, "LSP: Signature help", "i")
keymap("<leader>df", vim.diagnostic.open_float, "LSP: Show diagnostic message", "n")
keymap("<leader>tt", "<cmd>tabnew<cr><cmd>term<cr>", "Open terminal in a new tab")
keymap("<leader>tn", "<cmd>tabnew<cr>", "Open new tab")
keymap("<Esc>", "<C-\\><C-n>", "Terminal mode easy exit", "t")
keymap("]t", "<cmd>tabnext<cr>", "Tab next")
keymap("[t", "<cmd>tabprevious<cr>", "Tab previous")
keymap("<C-g>", function()
    require("neogit").open({ kind = "replace" })
end, "Neogit")
keymap("<leader>lR", "<cmd>LspRestart<cr>", "LSP: Restart language server")
keymap("<A-F>", function()
    require("conform").format({
        async = true,
        stop_after_first = true,
        lsp_format = "fallback",
    })
end, "LSP: Format buffer")
keymap("yig", ":%y<CR>", "Yank buffer", "n")
keymap("vig", "ggVG", "Visual select buffer", "n")
keymap("cig", ":%d<CR>i", "Change buffer", "n")
keymap("<leader>fc", function()
    require("telescope.builtin").colorscheme({ enable_preview = true })
end, "Find Colorscheme")

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

keymap("<leader>qf", toggle_qf, "Quickfixlist close")
keymap("<leader>qn", "<cmd>cnext<cr>", "Quickfixlist next")
keymap("<leader>qp", "<cmd>cprevious<cr>", "Quickfixlist previous")
--

keymap("<leader>i", "<cmd>Inspect<cr>", "Inspect")
keymap("<leader>zm", "<cmd>ZenMode<cr>", "Zen mode")
keymap("<leader>st", function()
    vim.opt.spell = not vim.opt.spell:get()
end, "Toggle spellchecking")

--#region CopilotChat
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
--

keymap("<leader>th", "<cmd>TSToggle highlight<cr>", "Toggle treesitter highlight")

--#region Gitsigns
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
--

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
--

-- Overseer
keymap("<leader>tl", "<cmd>OverseerToggle<cr>", "Task List")
keymap("<leader>tr", "<cmd>OverseerRun<cr>", "Task Run")
