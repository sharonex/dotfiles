-- nicer lsp diagnostics icons
local signs = { Error = "", Warn = "", Hint = "󰌵", Info = "" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

require("configs.lsp.lua_ls")
require("configs.lsp.rust-analyzer")
require("configs.lsp.typescript-language-server")

