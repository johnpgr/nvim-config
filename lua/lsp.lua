local servers = {}
local lsp_dir = vim.fn.stdpath("config") .. "/lsp"

for file in vim.fs.dir(lsp_dir) do
    if file:match("%.lua$") then
        local server_name = file:gsub("%.lua$", "")
        table.insert(servers, server_name)
    end
end

vim.lsp.enable(servers)

local function common_on_attach(client, bufnr)
	require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
end

local capabilities = require("blink.cmp").get_lsp_capabilities()

return {
    capabilities = capabilities,
    common_on_attach = common_on_attach
}
