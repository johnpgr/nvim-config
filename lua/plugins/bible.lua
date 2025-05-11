return {
"johnpgr/bible-reader.nvim",
    config = function()
        require("bible-reader").setup({
            translation = "pt_nvi",
            language = "pt_br",
            format = {
                break_verses = false,
                max_line_length = 80,
                indent_size = 4,
                verse_spacing = 0,
                chapter_header = true,
            },
        })
    end,
}
