---@param desc string
---@return table
local default_opts = function(desc) return { noremap = true, silent = true, desc = desc } end
local map = vim.keymap.set
local default_modes = { "n", "v" }
local togglers = require "utils.toggle"
local pickers = require "utils.telescope-pickers"

-- (Ctrl+Alt+n) Select all occurrences of word under cursor
vim.cmd [[
    nmap <C-M-n> <Plug>(VM-Select-All)
    imap <C-M-n> <ESC><Plug>(VM-Select-All)
    vmap <C-M-n> <ESC><Plug>(VM-Select-All)
]]

map(default_modes, "<leader>/", pickers.buffer_fuzzy_find, default_opts("Advanced current buffer fuzzy finder"))
map(default_modes, "<leader>?", require("telescope.builtin").oldfiles, default_opts("List recent files"))
map(default_modes, "<leader>sc", require("telescope.builtin").colorscheme, default_opts("Change colorscheme"))
map(default_modes, "<leader>C", pickers.list_nvim_config_files, default_opts("Search neovim config files"))
map(default_modes, "<leader>S", require("spectre").open, default_opts("Spectre"))
map(default_modes, "<leader>T", function() require("trouble").toggle "diagnostics" end, default_opts("Trouble"))
map(default_modes, "<leader>U", "<cmd>UndotreeToggle<cr>", default_opts("Undotree"))
map(default_modes, "<leader>tc", require("copilot.suggestion").toggle_auto_trigger,
    default_opts("Toggle copilot suggestions"))
map(default_modes, "<leader>ts", togglers.toggle_spaces_width, default_opts("Toggle spaces amount/tab size"))
map(default_modes, "<leader>ti", togglers.toggle_tabs_and_spaces, default_opts("Toggle indentation mode"))
map(default_modes, "<leader>tb", require("gitsigns").toggle_current_line_blame, default_opts("Toggle Git Blame"))
map("n", "<leader>tn", "<cmd>tabnew<cr>", default_opts("New Tab"))
map("n", "<leader>tt", "<cmd>tabnew<cr><cmd>terminal<cr>", default_opts("New terminal in new tab"))
map(default_modes, "<leader>sc", "<cmd>TextCaseOpenTelescope<cr>", default_opts("Text case converter"))
map(default_modes, "<leader>ss", pickers.list_spell_suggestions_under_cursor,
    default_opts("List spell suggestions for current word under cursor"))
map(default_modes, "<leader>sg", require("telescope.builtin").git_files, default_opts("List Git files"))
map(default_modes, "<leader>sw", pickers.grep_string_under_cursor, default_opts("List occurrences of word under cursor"))
map(default_modes, "<leader>sr", pickers.list_recent_files, default_opts("List recently opened files"))
map(default_modes, "<leader><space>", require("telescope.builtin").buffers, default_opts("List open buffers"))
map(default_modes, "<leader>df", vim.diagnostic.open_float, default_opts("Open floating diagnostic message"))
map(default_modes, "<leader>dl", require("telescope.builtin").diagnostics, default_opts("List diagnostic messages"))
map(default_modes, "<leader>gb", "<cmd>Git blame<cr>", default_opts("Git blame"))
map(default_modes, "<leader>gh", require("gitsigns").preview_hunk, default_opts("Git hunk"))
map(default_modes, "[d", vim.diagnostic.goto_prev, default_opts("Goto next LSP diagnostic"))
map(default_modes, "]d", vim.diagnostic.goto_next, default_opts("Goto previous LSP diagnostic"))
map(default_modes, "<leader>v", ":vsplit<CR>", default_opts("Split vertical"))
map(default_modes, "<leader>h", ":split<CR>", default_opts("Split horizontal"))
map("v", "J", ":m '>+1<CR>gv=gv", default_opts("Move line down"))
map("v", "K", ":m '<-2<CR>gv=gv", default_opts("Move line up"))
map(default_modes, "<C-p>", pickers.list_files_cwd, default_opts("List files"))
map(default_modes, "<C-f>", pickers.live_grep, default_opts("Live grep"))
map(default_modes, "<C-g>", "<cmd>LazyGit<cr>", default_opts("LazyGit"))
map("v", "<", "<gv", default_opts("Keep selection when indenting multiple lines"))
map("v", ">", ">gv", default_opts("Keep selection when indenting multiple lines"))
map(default_modes, "<C-d>", "<C-d>zz", default_opts("Better scroll down"))
map(default_modes, "<C-u>", "<C-u>zz", default_opts("Better scroll up"))
map(default_modes, "<leader>e", "<cmd>Oil<cr>", default_opts("Open explorer"))
map("i", "<C-d>", require("copilot.suggestion").dismiss, default_opts("Dismiss copilot suggestion"))
map("n", "<Esc>", "<cmd>noh<cr>", default_opts("Dismiss search highlights"))
map("n", "K", vim.lsp.buf.hover, default_opts("Hover Documentation"))
map(default_modes, "gd", function() require("trouble").toggle "lsp_definitions" end, default_opts("Goto definition"))
map(default_modes, "gD", function() require("trouble").toggle "lsp_type_definitions" end,
    default_opts("Goto type definition"))
map(default_modes, "gr", function() require("trouble").toggle "lsp_references" end, default_opts("Goto references"))
map("t", "<Esc>", "<C-\\><C-n>", default_opts("Terminal mode easy exit"))
map(default_modes, "<M-]>", "<cmd>tabnext<cr>", default_opts("Tab next"))
map(default_modes, "<M-[>", "<cmd>tabprevious<cr>", default_opts("Tab previous"))
map(default_modes, "<C-s>", "<cmd>mksession<cr> <cmd>lua print('New session: ' .. vim.fn.getcwd() .. '/Session.vim')<cr>",
    default_opts("Create new session"))
map(default_modes, "<F1>", ":SplitrunNew ", default_opts("Split run"))
