-- Sourced from: https://github.com/miszo/dotfiles/blob/main/home/dot_config/exact_nvim/exact_lua/exact_utils/exact_telescope/image.lua
local previewers = require "telescope.previewers"
local image_api = require "image"

local M = {}
local is_image_preview = false
local image = nil
local last_file_path = ""

local supported_images = { "png", "jpg", "jpeg", "gif", "webp", "avif" }

M.get_hijack_images_patterns = function()
    local patterns = {}

    for _, extension in ipairs(supported_images) do
        table.insert(patterns, string.format("*.%s", extension))
    end

    return patterns
end

M.get_extension = function(filepath)
    local split_path = vim.split(filepath:lower(), ".", { plain = true })
    return split_path[#split_path]
end

M.is_supported_image = function(filepath)
    local extension = M.get_extension(filepath)
    return vim.tbl_contains(supported_images, extension)
end

local delete_image = function()
    if not image then return end

    image:clear()

    is_image_preview = false
end

local create_image = function(filepath, winid, bufnr)
    image = image_api.hijack_buffer(filepath, winid, bufnr)

    if not image then return end

    vim.schedule(function() image:render() end)

    is_image_preview = true
end

M.buffer_previewer_maker = function(filepath, bufnr, opts)
    -- NOTE: Clear image when preview other file
    if is_image_preview and last_file_path ~= filepath then delete_image() end

    last_file_path = filepath

    if M.is_supported_image(filepath) then
        create_image(filepath, opts.winid, bufnr)
    else
        previewers.buffer_previewer_maker(filepath, bufnr, opts)
    end
end

M.teardown = function(_)
    if is_image_preview then delete_image() end
end

return M
