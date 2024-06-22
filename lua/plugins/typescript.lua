return {
    {
        "dmmulroy/ts-error-translator.nvim",
        config = function() require("ts-error-translator").setup() end,
    },
    {
        "razak17/twoslash-queries.nvim",
        keys = {
            { "<leader>lI", "<Cmd>TwoslashQueriesInspect<CR>", desc = "twoslash-queries: inspect" },
        },
        opts = { highlight = "DiagnosticVirtualTextInfo" },
    },
    {
        "dmmulroy/tsc.nvim",
        cmd = "TSC",
        ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        opts = {
            enable_progress_notifications = true,
            auto_open_qflist = true,
        },
        config = function(_, opts)
            require("tsc").setup(opts)

            -- Replace the quickfix window with Trouble when viewing TSC results
            local function replace_quickfix_with_trouble()
                local qflist = vim.fn.getqflist { title = 0, items = 0 }

                if qflist.title ~= "TSC" then return end

                local ok, trouble = pcall(require, "trouble")

                if ok then
                    -- close trouble if there are no more items in the quickfix list
                    if next(qflist.items) == nil then
                        vim.defer_fn(trouble.close, 0)
                        return
                    end

                    vim.defer_fn(function()
                        vim.cmd "cclose"
                        trouble.open "quickfix"
                    end, 0)
                end
            end

            vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
                pattern = "quickfix",
                callback = replace_quickfix_with_trouble,
            })
        end,
    },
}
