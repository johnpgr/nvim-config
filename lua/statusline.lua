local function lsp_status()
    local attached_clients = vim.lsp.get_clients({ bufnr = 0 })
    if #attached_clients == 0 then
        return ""
    end

    -- Filter out copilot and get client names
    local names = vim.iter(attached_clients)
        :filter(function(client)
            return client.name ~= "copilot" and client.name ~= "htmx"
        end)
        :map(function(client)
            local name = client.name:gsub("language.server", "ls")
            return name
        end)
        :totable()

    if #names == 0 then
        return ""
    elseif #names == 1 then
        return "(" .. names[1] .. ")"
    else
        return string.format("(%s +%d)", names[1], #names - 1)
    end
end

function _G.statusline()
    return table.concat({
        "%f",
        "%h%w%m%r",
        "%=",
        lsp_status(),
        " %-14(%l,%c%V%)",
        "%P",
    }, " ")
end

vim.o.statusline = "%{%v:lua._G.statusline()%}"
