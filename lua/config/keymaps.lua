local map = vim.keymap.set
local default_modes = { "n", "v" }
local default_opts = { noremap = true, silent = true }
local togglers = require "utils.toggle"
local pickers = require "utils.telescope-pickers"
local harpoon = require "harpoon"

-- (Ctrl+Alt+n) Select all occurrences of word under cursor
vim.cmd [[
    nmap <C-M-n> <Plug>(VM-Select-All)
    imap <C-M-n> <ESC><Plug>(VM-Select-All)
    vmap <C-M-n> <ESC><Plug>(VM-Select-All)
]]

-- Advanced current buffer fuzzy finder
map(default_modes, "<leader>/", pickers.buffer_fuzzy_find, default_opts)
-- List recent files
map(default_modes, "<leader>?", require("telescope.builtin").oldfiles, default_opts)
map(
    default_modes,
    "<leader>sc",
    function() require("telescope.builtin").colorscheme { enable_preview = true } end,
    default_opts
)
-- List nvim cfg files
map(default_modes, "<leader>C", pickers.list_nvim_config_files, default_opts)
-- Spectre
map(default_modes, "<leader>S", require("spectre").open, default_opts)
-- Trouble
map(default_modes, "<leader>T", function() require("trouble").toggle "diagnostics" end, default_opts)
-- Undotree
map(default_modes, "<leader>U", "<cmd>UndotreeToggle<cr>", default_opts)
-- Toggle copilot suggestions
map(default_modes, "<leader>tc", require("copilot.suggestion").toggle_auto_trigger, default_opts)
-- Toggle spaces amount/tab size
map(default_modes, "<leader>ts", togglers.toggle_spaces_width, default_opts)
-- Toggle indentation mode
map(default_modes, "<leader>ti", togglers.toggle_tabs_and_spaces, default_opts)
-- Toggle Git Blame
map(default_modes, "<leader>tb", require("gitsigns").toggle_current_line_blame, default_opts)
-- Open new tab
map("n", "<leader>tn", "<cmd>tabnew<cr>", default_opts)
-- Open new terminal in new tab
map("n", "<leader>tt", "<cmd>tabnew<cr><cmd>terminal<cr>", default_opts)
-- Text case converter
map(default_modes, "<leader>cc", "<cmd>TextCaseOpenTelescope<cr>", default_opts)
-- List spell suggestions for current word under cursor
map(default_modes, "<leader>ss", pickers.list_spell_suggestions_under_cursor, default_opts)
-- List Git files
map(default_modes, "<leader>sg", require("telescope.builtin").git_files, default_opts)
-- List occurrences of word under cursor
map(default_modes, "<leader>sw", pickers.grep_string_under_cursor, default_opts)
-- List recently opened files
map(default_modes, "<leader>sr", pickers.list_recent_files, default_opts)
-- List open buffers
map(default_modes, "<leader>sb", require("telescope.builtin").buffers, default_opts)
-- Open floating diagnostic message
map(default_modes, "<leader>df", vim.diagnostic.open_float, default_opts)
-- List diagnostic messages
map(default_modes, "<leader>dl", require("telescope.builtin").diagnostics, default_opts)
-- Git blame
map(default_modes, "<leader>gb", "<cmd>Git blame<cr>", default_opts)
-- Git hunk
map(default_modes, "<leader>gh", require("gitsigns").preview_hunk, default_opts)
-- Goto next LSP diagnostic
map(default_modes, "[d", vim.diagnostic.goto_prev, default_opts)
-- Goto previous LSP diagnostic
map(default_modes, "]d", vim.diagnostic.goto_next, default_opts)
-- Split vertical
map(default_modes, "<leader>v", ":vsplit<CR>", default_opts)
-- Split horizontal
map(default_modes, "<leader>h", ":split<CR>", default_opts)
-- Resize horizontal ++
-- map(default_modes, "<C-up>", ":horizontal resize +3<CR>", default_opts)
-- -- Resize horizontal --
-- map(default_modes, "<C-down>", ":horizontal resize -3<CR>", default_opts)
-- -- Resize vertical ++
-- map(default_modes, "<C-left>", ":vertical resize +3<CR>", default_opts)
-- -- Resize vertical --
-- map(default_modes, "<C-right>", ":vertical resize -3<CR>", default_opts)
-- -- Jump to left split/window
-- map(default_modes, "<C-h>", "<C-w>h", default_opts)
-- -- Jump to right split/window
-- map(default_modes, "<C-l>", "<C-w>l", default_opts)
-- -- Jump to below split/window
-- map(default_modes, "<C-j>", "<C-w>j", default_opts)
-- -- Jump to upper split/window
-- map(default_modes, "<C-k>", "<C-w>k", default_opts)
-- Move line down
map("v", "J", ":m '>+1<CR>gv=gv", default_opts)
-- Move line up
map("v", "K", ":m '<-2<CR>gv=gv", default_opts)
-- List files
map(default_modes, "<C-p>", pickers.list_files_cwd, default_opts)
-- Live grep
map(default_modes, "<C-f>", pickers.live_grep, default_opts)
-- LazyGit
map(default_modes, "<C-g>", "<cmd>LazyGit<cr>", default_opts)
-- Keep selection when indenting multiple lines
map("v", "<", "<gv", default_opts)
-- Keep selection when indenting multiple lines
map("v", ">", ">gv", default_opts)
-- Better comment toggle NORMAL mode
-- map("n", "<C-/>", "gcc", { remap = true })
-- Better comment toggle VISUAL mode
-- map("v", "<C-/>", "gc", { remap = true })
-- Better scroll down
map(default_modes, "<C-d>", "<C-d>zz", default_opts)
-- Better scroll up
map(default_modes, "<C-u>", "<C-u>zz", default_opts)
-- Open explorer
map(default_modes, "<leader>e", "<cmd>Oil<cr>", default_opts)
-- Dismiss copilot suggestion
map("i", "<C-d>", require("copilot.suggestion").dismiss, default_opts)
-- Dismiss search highlights
map("n", "<Esc>", "<cmd>noh<cr>", default_opts)
-- Hover Documentation
map("n", "K", vim.lsp.buf.hover, default_opts)
-- Goto definition
map(default_modes, "gd", function() require("trouble").toggle "lsp_definitions" end, default_opts)
-- Goto type definition
map(default_modes, "gD", function() require("trouble").toggle "lsp_type_definitions" end, default_opts)
-- Goto references
-- map(default_modes, "gr", require("telescope.builtin").lsp_references, default_opts)
map(default_modes, "gr", function() require("trouble").toggle "lsp_references" end, default_opts)
-- Add file to Harpoon list
map(default_modes, "<leader>a", function() harpoon:list():add() end, default_opts)
-- Toggle Harpoon list
-- map(default_modes, '<leader><space>', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, default_opts)
map(default_modes, "<leader><space>", function() require("utils.harpoon").toggle_telescope(harpoon:list()) end)
-- Select Harpoon mark 1
map(default_modes, "<leader>1", function() harpoon:list():select(1) end, default_opts)
-- Select Harpoon mark 2
map(default_modes, "<leader>2", function() harpoon:list():select(2) end, default_opts)
-- Select Harpoon mark 3
map(default_modes, "<leader>3", function() harpoon:list():select(3) end, default_opts)
-- Select Harpoon mark 4
map(default_modes, "<leader>4", function() harpoon:list():select(4) end, default_opts)
-- Terminal mode easy exit
map("t", "<Esc>", "<C-\\><C-n>", default_opts)
-- Tab niceties
map(default_modes, "<M-]>", "<cmd>tabnext<cr>", default_opts)
map(default_modes, "<M-[>", "<cmd>tabprevious<cr>", default_opts)
-- Create new session
map(
    default_modes,
    "<C-s>",
    "<cmd>mksession<cr> <cmd>lua print('New session: ' .. vim.fn.getcwd() .. '/Session.vim')<cr>",
    default_opts
)
