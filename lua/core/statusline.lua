-- this is default statusline value
-- vim.o.statusline = [[%f %h%w%m%r%=%-14.(%l,%c%V%) %P]]

-- below is simple example of custom statusline using neovim APIs

---Show attached LSP clients in `[name1, name2]` format.
---Long server names will be modified. For example, `lua-language-server` will be shorten to `lua-ls`
---Returns an empty string if there aren't any attached LSP clients.
---@return string
local function lsp_status()
    local attached_clients = vim.lsp.get_clients({ bufnr = 0 })
    if #attached_clients == 0 then
        return ""
    end
    local it = vim.iter(attached_clients)
    it:map(function(client)
        local name = client.name:gsub("language.server", "ls")
        return name
    end)
    local names = it:totable()
    return "[" .. table.concat(names, ", ") .. "]"
end

local function git_branch()
    -- Get current branch withou any plugins
    local branch = vim.fn.systemlist("git rev-parse --abbrev-ref HEAD")[1]
    if branch:find("fatal: not a git repository") then
        return ""
    end

    return branch ~= "" and "[" .. branch .. "]" or " "
end

function _G.statusline()
    return table.concat({
        "%f %m",
        git_branch(),
        "%h%w%r",
        "%=",
        lsp_status(),
        " %-14(%l,%c%V%)",
        "%P"
    }, " ")
end

vim.o.statusline = "%{%v:lua._G.statusline()%}"
