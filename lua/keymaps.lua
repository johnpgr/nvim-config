local map = vim.keymap.set
local default_modes = { 'n', 'v' }
local default_opts = { noremap = true, silent = true }
local gs = package.loaded.gitsigns
local togglers = require('utils.toggle')
local harpoon = require('harpoon')

local function buffer_fuzzy_find()
	require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown())
end

local function list_nvim_config_files()
	require('utils.pretty-telescope').pretty_files_picker({
		picker = "find_files",
		options = {
			cwd = vim.fn.stdpath("config"),
			hidden = false,
		}
	})
end

local function list_spell_suggestions_under_cursor()
	require("telescope.builtin").spell_suggest(require("telescope.themes").get_cursor({}))
end

local function grep_string_under_cursor()
	require("utils.pretty-telescope").pretty_grep_picker({ picker = "grep_string" })
end

local function list_recent_files()
	require("utils.pretty-telescope").pretty_files_picker({ picker = "oldfiles", options = { only_cwd = true } })
end

local function list_files_cwd()
	require('utils.pretty-telescope').pretty_files_picker({ picker = "find_files" })
end

local function live_grep()
	require("utils.pretty-telescope").pretty_grep_picker({ picker = "live_grep" })
end

-- don't override the built-in and fugitive keymaps
-- Jump to next hunk
map(default_modes, ']h', function()
	if vim.wo.diff then return ']h' end
	vim.schedule(function() gs.next_hunk() end)
	return '<Ignore>'
end, { expr = true, noremap = true, silent = true })
-- Jump to previous hunk
map(default_modes, '[h', function()
	if vim.wo.diff then return '[h' end
	vim.schedule(function() gs.prev_hunk() end)
	return '<Ignore>'
end, { expr = true, noremap = true, silent = true })

-- (Ctrl+Alt+n) Select all occurrences of word under cursor
vim.cmd([[
    nmap <C-M-n> <Plug>(VM-Select-All)
    imap <C-M-n> <ESC><Plug>(VM-Select-All)
    vmap <C-M-n> <ESC><Plug>(VM-Select-All)
]])

-- Advanced fuzzy finder
-- map(default_modes, '<leader>/', buffer_fuzzy_find, default_opts)
-- List recent files
map(default_modes, '<leader>?', require('telescope.builtin').oldfiles, default_opts)
-- List buffers
map(default_modes, '<leader><Space>', require('telescope.builtin').buffers, default_opts)
-- List nvim cfg files
map(default_modes, '<leader>C', list_nvim_config_files, default_opts)
-- Spectre
map(default_modes, '<leader>S', require('spectre').open, default_opts)
-- Undotree
map(default_modes, '<leader>U', '<cmd>UndotreeToggle<cr>', default_opts)
-- Toggle copilot suggestions
map(default_modes, '<leader>tc', require('copilot.suggestion').toggle_auto_trigger, default_opts)
-- Toggle spaces amount/tab size
map(default_modes, '<leader>ts', togglers.toggle_spaces_width, default_opts)
-- Toggle indentation mode
map(default_modes, '<leader>ti', togglers.toggle_tabs_and_spaces, default_opts)
-- Toggle Git Blame
map(default_modes, '<leader>tb', require('gitsigns').toggle_current_line_blame, default_opts)
-- Text case converter
map(default_modes, '<leader>cc', '<cmd>TextCaseOpenTelescope<cr>', default_opts)
-- List spell suggestions for current word under cursor
map(default_modes, '<leader>ss', list_spell_suggestions_under_cursor, default_opts)
-- List Git files
map(default_modes, '<leader>sg', require('telescope.builtin').git_files, default_opts)
-- List occurrences of word under cursor
map(default_modes, '<leader>sw', grep_string_under_cursor, default_opts)
-- List recently opened files
map(default_modes, '<leader>sr', list_recent_files, default_opts)
-- Open floating diagnostic message
map(default_modes, '<leader>df', vim.diagnostic.open_float, default_opts)
-- List diagnostic messages
map(default_modes, '<leader>dl', require('telescope.builtin').diagnostics, default_opts)
-- Git blame
map(default_modes, '<leader>gb', '<cmd>Git blame<cr>', default_opts)
-- Git hunk
map(default_modes, '<leader>gh', require('gitsigns').preview_hunk, default_opts)
-- Goto next LSP diagnostic
map(default_modes, '[d', vim.diagnostic.goto_prev, default_opts)
-- Goto previous LSP diagnostic
map(default_modes, ']d', vim.diagnostic.goto_next, default_opts)
-- Split vertical
map(default_modes, '<leader>v', ':vsplit<CR>', default_opts)
-- Split horizontal
map(default_modes, '<leader>h', ':split<CR>', default_opts)
-- Resize horizontal ++
map(default_modes, '<C-up>', ':horizontal resize +3<CR>', default_opts)
-- Resize horizontal --
map(default_modes, '<C-down>', ':horizontal resize -3<CR>', default_opts)
-- Resize vertical ++
map(default_modes, '<C-left>', ':vertical resize +3<CR>', default_opts)
-- Resize vertical --
map(default_modes, '<C-right>', ':vertical resize -3<CR>', default_opts)
-- Move line down
map('v', 'J', ":m '>+1<CR>gv=gv", default_opts)
-- Move line up
map('v', 'K', ":m '<-2<CR>gv=gv", default_opts)
-- List files
map(default_modes, '<C-p>', list_files_cwd, default_opts)
-- Live grep
map(default_modes, '<C-f>', live_grep, default_opts)
-- LazyGit
map(default_modes, '<C-g>', '<cmd>LazyGit<cr>', default_opts)
-- Keep selection when indenting multiple lines
map('v', '<', '<gv', default_opts)
-- Keep selection when indenting multiple lines
map('v', '>', '>gv', default_opts)
-- Better scroll down
map(default_modes, '<C-d>', '<C-d>zz', default_opts)
-- Better scroll up
map(default_modes, '<C-u>', '<C-u>zz', default_opts)
-- Open explorer
map(default_modes, '<leader>e', '<cmd>Oil<cr>', default_opts)
-- Dismiss copilot suggestion
map('i', '<C-d>', require('copilot.suggestion').dismiss, default_opts)
-- Dismiss search highlights
map('n', '<Esc>', '<cmd>noh<cr>', default_opts)
-- Hover Documentation
map(default_modes, 'K', vim.lsp.buf.hover, default_opts)
-- Goto definition
map(default_modes, 'gd', require('telescope.builtin').lsp_definitions, default_opts)
-- Goto type definition
map(default_modes, 'gD', require('telescope.builtin').lsp_type_definitions, default_opts)
-- Goto references
map(default_modes, 'gr', require('telescope.builtin').lsp_references, default_opts)
-- Add file to Harpoon list
map(default_modes, '<leader>a', function() harpoon:list():add() end, default_opts)
-- Toggle Harpoon list
map(default_modes, '<leader><space>', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, default_opts)
-- Select Harpoon mark 1
map(default_modes, '<leader>1', function() harpoon:list():select(1) end, default_opts)
-- Select Harpoon mark 2
map(default_modes, '<leader>2', function() harpoon:list():select(2) end, default_opts)
-- Select Harpoon mark 3
map(default_modes, '<leader>3', function() harpoon:list():select(3) end, default_opts)
-- Select Harpoon mark 4
map(default_modes, '<leader>4', function() harpoon:list():select(4) end, default_opts)
