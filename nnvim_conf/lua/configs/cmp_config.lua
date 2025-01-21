local ELLIPSIS_CHAR = '…'
local MAX_LABEL_WIDTH = 25
local MAX_KIND_WIDTH = 14

local get_ws = function(max, len)
  return (" "):rep(max - len)
end

local format = function(_, item)
  local content = item.abbr
  -- local kind_symbol = symbols[item.kind]
  -- item.kind = kind_symbol .. get_ws(MAX_KIND_WIDTH, #kind_symbol)

  if #content > MAX_LABEL_WIDTH then
    item.abbr = vim.fn.strcharpart(content, 0, MAX_LABEL_WIDTH) .. ELLIPSIS_CHAR
  else
    item.abbr = content .. get_ws(MAX_LABEL_WIDTH, #content)
  end

  return item
end

return function()
  local cmp = require 'cmp'
  cmp.setup {
    formatting = {
      format = require('lspkind').cmp_format(),
      -- format = format,
      mode = "symbol_text",
    },
    snippet = {
      expand = function(args)
      end,
    },
    completion = {
      completeopt = 'menu,menuone,noinsert'
    },
    mapping = cmp.mapping.preset.insert {
      ['<C-n>'] = cmp.mapping.select_next_item(),
      ['<C-p>'] = cmp.mapping.select_prev_item(),
      -- Commented out since I use C-f for from tpope/rsi
      -- ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      -- ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
      ['<S-CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end, { 'i', 's' }),
    },
    sources = {
      { name = 'nvim_lsp' },
    }
  }
end
