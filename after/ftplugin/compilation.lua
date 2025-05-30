local function map(lhs, rhs, opts)
    vim.keymap.set('n', lhs, rhs, vim.tbl_extend('force', opts or {}, { buffer = true }))
end

map("]e", "<cmd>CompileNextError<cr>", { desc = "Next compilation error" })
map("[e", "<cmd>CompilePrevError<cr>", { desc = "Previous compilation error" })
map("R", "<cmd>Recompile<cr>", { desc = "Recompile" })
