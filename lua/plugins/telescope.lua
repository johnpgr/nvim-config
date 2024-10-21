-- Image previewer
local previewers = require("telescope.previewers")
local is_image_preview = false
local image = nil
local last_file_path = ""
local from_entry = require("telescope.from_entry")
local Path = require("plenary.path")
local conf = require("telescope.config").values
local Previewers = require("telescope.previewers")

local supported_images = { "png", "jpg", "jpeg", "gif", "webp", "avif" }

local get_hijack_images_patterns = function()
    local patterns = {}

    for _, extension in ipairs(supported_images) do
        table.insert(patterns, string.format("*.%s", extension))
    end

    return patterns
end

local get_extension = function(filepath)
    local split_path = vim.split(filepath:lower(), ".", { plain = true })
    return split_path[#split_path]
end

local is_supported_image = function(filepath)
    local extension = get_extension(filepath)
    return vim.tbl_contains(supported_images, extension)
end

local delete_image = function()
    if not image then
        return
    end

    image:clear()

    is_image_preview = false
end

local create_image = function(filepath, winid, bufnr)
    image = require("image").hijack_buffer(filepath, winid, bufnr)

    if not image then
        return
    end

    vim.schedule(function()
        image:render()
    end)

    is_image_preview = true
end

local buffer_previewer_maker = function(filepath, bufnr, opts)
    -- NOTE: Clear image when preview other file
    if is_image_preview and last_file_path ~= filepath then
        delete_image()
    end

    last_file_path = filepath

    if is_supported_image(filepath) then
        create_image(filepath, opts.winid, bufnr)
    else
        previewers.buffer_previewer_maker(filepath, bufnr, opts)
    end
end

local buffer_previewers = {
    teardown = function(_)
        if is_image_preview then
            delete_image()
        end
    end,
}

local defaulter = function(f, default_opts)
    default_opts = default_opts or {}
    return {
        new = function(opts)
            if conf.preview == false and not opts.preview then
                return false
            end
            opts.preview = type(opts.preview) ~= "table" and {} or opts.preview
            if type(conf.preview) == "table" then
                for k, v in pairs(conf.preview) do
                    opts.preview[k] = vim.F.if_nil(opts.preview[k], v)
                end
            end
            return f(opts)
        end,
        __call = function()
            local ok, err = pcall(f(default_opts))
            if not ok then
                error(debug.traceback(err))
            end
        end,
    }
end

-- NOTE: Add teardown to cat previewer to clear image when close Telescope
buffer_previewers.cat = defaulter(function(opts)
    opts = opts or {}
    local cwd = opts.cwd or vim.loop.cwd()
    return Previewers.new_buffer_previewer({
        title = "File Preview",
        dyn_title = function(_, entry)
            return Path:new(from_entry.path(entry, true)):normalize(cwd)
        end,

        get_buffer_by_name = function(_, entry)
            return from_entry.path(entry, true)
        end,

        define_preview = function(self, entry, _)
            local p = from_entry.path(entry, true)
            if p == nil or p == "" then
                return
            end

            conf.buffer_previewer_maker(p, self.state.bufnr, {
                bufname = self.state.bufname,
                winid = self.state.winid,
                preview = opts.preview,
            })
        end,

        teardown = buffer_previewers.teardown,
    })
end, {})

local is_neovide = vim.g.neovide ~= nil
local is_kitty = os.getenv("TERM") == "xterm-kitty"

return {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    branch = "0.1.x",
    dependencies = {
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            cond = function()
                return vim.fn.executable("make") == 1
            end,
        },
        {
            "johmsalas/text-case.nvim",
            config = function()
                require("textcase").setup({})
            end,
        },
        { "nvim-telescope/telescope-ui-select.nvim" },
    },
    config = function()
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")

        require("telescope").setup({
            defaults = {
                mappings = {
                    i = {
                        ["<C-u>"] = false,
                    },
                },
                buffer_previewer_maker = not is_neovide and is_kitty and buffer_previewer_maker or nil,
                file_previewer = not is_neovide and is_kitty and buffer_previewers.cat.new or nil,
            },
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown(),
                },
            },
            pickers = {
                buffers = {
                    previewer = false,
                    theme = "dropdown",
                    mappings = {
                        i = {
                            ["<C-d>"] = actions.delete_buffer,
                        },
                    },
                },
                colorscheme = {
                    mappings = {
                        i = {
                            ["<CR>"] = function(bufnr)
                                local selection = action_state.get_selected_entry()
                                local new = selection.value
                                local file = io.open(vim.fn.stdpath("config") .. "/lua/colorscheme.lua", "w")

                                actions.close(bufnr)
                                vim.cmd.colorscheme(new)
                                if file then
                                    file:write('vim.cmd.colorscheme("' .. new .. '")')
                                    file:close()
                                end
                            end,
                        },
                    },
                },
            },
        })
    end,
    init = function()
        local t = require("telescope")
        t.load_extension("fzf")
        t.load_extension("textcase")
        t.load_extension("ui-select")
    end,
}
