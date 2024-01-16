local M = {}
-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
M.servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  tsserver = {},
  -- html = { filetypes = { 'html', 'twig', 'hbs'} },

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      diagnostics = { disable = { 'missing-fields' }, globals = { 'vim' } },
      hint = { enable = true },
    },
  },
}

M.lines_enabled = true
M.toggle_lsp_lines = function()
  M.lines_enabled = not M.lines_enabled
  vim.diagnostic.config({
    virtual_lines = M.lines_enabled,
    virtual_text = not M.lines_enabled,
    severity_sort = not M.lines_enabled
  })
end
-- Start with virtual lines disabled
M.toggle_lsp_lines()

vim.diagnostic.config({
  severity_sort = true,
  virtual_text = true,
})

vim.keymap.set('n', '<leader>lq', M.toggle_lsp_lines, { desc = '[L]SP [Q]uickfix Toggle' })

-- Attach inlay hints. Should be unnecessary in neovim 0.10
vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
vim.api.nvim_create_autocmd("LspAttach", {
  group = "LspAttach_inlayhints",
  callback = function(args)
    if vim.fn.has('nvim-0.10') == 1 then
      print("In neovim 0.10")
      vim.lsp.inlay_hint.enable(0, true)
    else
      -- if not (args.data and args.data.client_id) then
      --   return
      -- end
      --
      -- local bufnr = args.buf
      -- local client = vim.lsp.get_client_by_id(args.data.client_id)
      -- require("lsp-inlayhints").on_attach(client, bufnr)
    end
  end,
})

-- vim.api.nvim_create_autocmd("LspAttach", {
--   group = "LspAttach_inlayhints",
--   callback = function(args)
--     if vim.fn.has('nvim-0.10') == 1 then
--       vim.lsp.inlay_hint.enable()
--     else
--       if not (args.data and args.data.client_id) then
--         return
--       end
--
--       local bufnr = args.buf
--       local client = vim.lsp.get_client_by_id(args.data.client_id)
--       require("lsp-inlayhints").on_attach(client, bufnr)
--       if client.server_capabilities.inlayHintProvider then
--         vim.g.inlay_hints_visible = true
--         vim.lsp.inlay_hint(0, true)
--       else
--         print("no inlay hints available")
--       end
--     end
--   end,
-- })

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
M.capabilities = capabilities
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true
}

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(M.servers),
}

-- nicer lsp diagnostics icons
local signs = { Error = "", Warn = "", Hint = "󰌵", Info = "" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = M.on_attach,
      settings = M.servers[server_name],
      filetypes = (M.servers[server_name] or {}).filetypes,
    }
  end,
}

return M
