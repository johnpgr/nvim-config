local utils = require("utils")
local telescope = require("telescope-utils")
local keymap = utils.keymap
local feedkeys = utils.feedkeys
local is_neovide = vim.g.neovide ~= nil

--Telescope
keymap("<leader>ff", telescope.list_files_cwd, "Find files")
keymap("<leader>fw", telescope.live_grep, "Find word")
keymap("<leader>nc", function()
    local dir = vim.fn.stdpath("config")
    feedkeys(":tabnew<CR>")
    feedkeys(":cd " .. dir .. "<CR>")
    feedkeys(":Oil<CR>")
end, "Neovim config")
keymap("<leader>tc", "<cmd>TextCaseOpenTelescope<cr>", "Text case converter")
keymap("<leader>ss", telescope.list_spell_suggestions_under_cursor, "Spell suggestions for word under cursor")
keymap("<leader>fg", require("telescope.builtin").git_files, "Find Git files")
keymap("<leader>w", telescope.grep_string_under_cursor, "List occurrences of word under cursor")
keymap("<leader>fo", telescope.list_recent_files, "Find oldfiles")
keymap("<leader><space>", require("telescope.builtin").buffers, "Open buffers")
keymap("<leader>dl", require("telescope.builtin").diagnostics, "Diagnostic messages")
keymap("<leader>fh", require("telescope.builtin").help_tags, "Find help tags")
--
keymap("<leader>ts", utils.toggle_spaces_width, "Toggle shift width")
keymap("<leader>ti", utils.toggle_indent_mode, "Toggle indentation mode")
keymap("<C-_>", "gcc", { remap = true, silent = true, desc = "Comment toggle" }, "n")
keymap("<C-_>", "gc", { remap = true, silent = true, desc = "Comment toggle" }, "v")
keymap("<C-/>", "gcc", { remap = true, silent = true, desc = "Comment toggle" }, "n")
keymap("<C-/>", "gc", { remap = true, silent = true, desc = "Comment toggle" }, "v")
keymap("<leader>e", "<cmd>Oil<cr>", "Explorer")
keymap("<C-k>", require("tmux").move_top, "Focus top split")
keymap("<C-l>", require("tmux").move_right, "Focus right split")
keymap("<C-j>", require("tmux").move_bottom, "Focus bottom split")
keymap("<C-h>", require("tmux").move_left, "Focus left split")
keymap("<A-k>", require("tmux").resize_top, "Focus top split")
keymap("<A-l>", require("tmux").resize_right, "Focus right split")
keymap("<A-j>", require("tmux").resize_bottom, "Focus bottom split")
keymap("<A-h>", require("tmux").resize_left, "Focus left split")
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
keymap("<leader>lr", require("nvchad.lsp.renamer"), "LSP: Rename variable", "n")
keymap("<F2>", require("nvchad.lsp.renamer"), "LSP: Rename variable", "n")
keymap("<leader>la", vim.lsp.buf.code_action, "LSP: Code actions")
keymap("<leader>ls", vim.lsp.buf.signature_help, "LSP: Signature help")
keymap("<C-s>", vim.lsp.buf.signature_help, "LSP: Signature help", "i")
keymap("<C-.>", vim.lsp.buf.code_action, "LSP: Code actions", "i")
keymap("K", vim.lsp.buf.hover, "LSP: Show hover message", "n")
keymap("<leader>df", vim.diagnostic.open_float, "LSP: Show diagnostic message", "n")
keymap("<F1>", function()
    feedkeys(":SplitrunNew ")
end, "Splitrun")
keymap("<leader>tt", "<cmd>tabnew<cr><cmd>term<cr>", "Open terminal in a new tab")
keymap("<leader>tn", "<cmd>tabnew<cr>", "Open new tab")
keymap("<C-\\>", function()
    require("nvchad.term").toggle({ pos = "bo vsp", id = "bovspTerm", size = 0.5 })
end, "Toggle terminal in vertical split", { "n", "t" })
keymap("<C-`>", function()
    require("nvchad.term").toggle({ pos = "bo sp", id = "bospTerm" })
end, "Toggle terminal in horizontal split", { "n", "t" })
keymap("TERM_VERT", function()
    require("nvchad.term").toggle({ pos = "bo sp", id = "bospTerm", size = 0.5 })
end, "Toggle terminal in vertical split", { "n", "t" })
keymap("<Esc>", "<C-\\><C-n>", "Terminal mode easy exit", "t")
keymap("]t", "<cmd>tabnext<cr>", "Tab next")
keymap("[t", "<cmd>tabprevious<cr>", "Tab previous")
keymap("<leader>lg", "<cmd>LazyGit<cr>", "Lazygit")
keymap("<leader>ld", "<cmd>LazyDocker<cr>", "Lazydocker")
keymap("<leader>fr", "<cmd>Spectre<cr>", "Find & replace")
keymap("<leader>lR", "<cmd>LspRestart<cr>", "LSP: Restart language server")
keymap("<leader>lf", function()
    require("conform").format({ stop_after_first = true, lsp_format = "fallback", async = true })
end, "LSP: Format buffer")
keymap("<leader>gh", "<cmd>Gitsigns preview_hunk<cr>", "Git hunk")
keymap("<leader>gb", "<cmd>Gitsigns blame<cr>", "Git blame")
keymap("<leader>gd", "<cmd>Gitsigns diffthis<cr>", "Git diff")
keymap("<leader>nd", "<cmd>Noice dismiss<cr>", "Dismiss noice messages")
keymap("yig", ":%y<CR>", "Yank buffer", "n")
keymap("vig", "ggVG", "Visual select buffer", "n")
keymap("cig", ":%d<CR>i", "Change buffer", "n")
keymap("<RightMouse>", function()
    vim.cmd.exec('"normal! \\<RightMouse>"')

    local options = vim.bo.ft == "NvimTree" and "nvimtree" or "default"
    require("menu").open(options, { mouse = true })
end, "Open context menu")
keymap("<leader>cs", function()
    require("nvchad.themes").open()
end, "Change colorscheme")
keymap("<leader>ch", "<cmd>NvCheatsheet<cr>", "Cheatsheet")
keymap("<leader>qc", "<cmd>cclose<cr>", "Quickfixlist close")
keymap("<leader>qo", "<cmd>copen<cr>", "Quickfixlist open")
keymap("<leader>qn", "<cmd>cnext<cr>", "Quickfixlist next")
keymap("<leader>qp", "<cmd>cprevious<cr>", "Quickfixlist previous")
keymap("<leader>R", function()
    local cfgdir = vim.fn.stdpath("config")
    local initlua = cfgdir .. "/init.lua"
    feedkeys(":source " .. initlua .. "<CR>")
    print("Reloaded " .. initlua)
end, "Reload neovim config")
keymap("<leader>zm", "<cmd>ZenMode<cr>", "Zen mode")
keymap("<leader>dc", require("dap").continue, "Debug: Continue")
keymap("<leader>do", require("dap").step_over, "Debug: Step over")
keymap("<leader>di", require("dap").step_into, "Debug: Step into")
keymap("<leader>dO", require("dap").step_out, "Debug: Step out")
keymap("<leader>db", require("dap").toggle_breakpoint, "Debug: Toggle breakpoint")
keymap("<leader>dB", function()
    require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, "Debug: Set breakpoint condition")

if is_neovide then
    keymap("<C-=>", function()
        local current_scale = vim.g.neovide_scale_factor
        vim.g.neovide_scale_factor = current_scale + 0.1
    end, "Increase font size")

    keymap("<C-->", function()
        local current_scale = vim.g.neovide_scale_factor
        vim.g.neovide_scale_factor = current_scale - 0.1
    end, "Decrease font size")
end
