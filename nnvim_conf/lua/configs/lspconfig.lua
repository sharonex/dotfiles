local M = {}

local lsp_mappings = function(_)
  vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })

  -- Rust
  vim.keymap.set("n", "<leader>re", "<Cmd>ExpandMacro<CR>", { desc = "Expand macro" })

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(0, "Format",
    vim.lsp.buf.format,
    { desc = "Format current buffer with LSP" })
end

-- nicer lsp diagnostics icons
local signs = { Error = "", Warn = "", Hint = "󰌵", Info = "" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.lsp.config('*', {
  capabilities = {
    textDocument = {
      semanticTokens = {
        multilineTokenSupport = true,
      }
    }
  },
  root_markers = { '.git' },
  on_attach = function(_, _)
    lsp_mappings()

    vim.diagnostic.config({
      severity_sort = true,
      virtual_text = true,
    })
  end
  ,
})

vim.lsp.config('rust-analyzer', {
  filetypes = { 'rust', 'rs' },
})

vim.lsp.config('lua_ls', {
  filetypes = { 'lua' },
})

vim.lsp.enable({ 'rust-analyzer', 'lua_ls' })

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
    if client:supports_method('textDocument/completion') then
      -- Optional: trigger autocompletion on EVERY keypress. May be slow!
      local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
      client.server_capabilities.completionProvider.triggerCharacters = chars

      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end

    -- Auto-format ("lint") on save.
    -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
    if not client:supports_method('textDocument/willSaveWaitUntil')
        and client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
        end,
      })
    end
  end,
})

require('vim.lsp.protocol').CompletionItemKind = {
  ' Text', -- Text
  ' Method', -- Method
  ' Function', -- Function
  ' Constructor', -- Constructor
  ' Field', -- Field
  ' Variable', -- Variable
  ' Class', -- Class
  'ﰮ Interface', -- Interface
  ' Module', -- Module
  ' Property', -- Property
  ' Unit', -- Unit
  ' Value', -- Value
  '了E num', -- Enum
  ' Keyword', -- Keyword
  '﬌ Snippet', -- Snippet
  ' Color', -- Color
  ' File', -- File
  ' Reference', -- Reference
  ' Folder', -- Folder
  ' EnumMember', -- EnumMember
  ' Constant', -- Constant
  ' Struct', -- Struct
  ' Event', -- Event
  'ﬦ Operator', -- Operator
  ' TypeParameter', -- TypeParameter
}
return M
