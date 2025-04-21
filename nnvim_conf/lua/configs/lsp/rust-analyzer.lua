local expandMacro = function()
    vim.lsp.buf_request_all(0, "rust-analyzer/expandMacro", vim.lsp.util.make_position_params(), function(result)
        -- Create a new tab
        vim.cmd("vsplit")
        vim.inspect(result)

        -- Create an empty scratch buffer (non-listed, non-file i.e scratch)
        -- :help nvim_create_buf
        local buf = vim.api.nvim_create_buf(false, true)

        -- and set it to the current window
        -- :help nvim_win_set_buf
        vim.api.nvim_win_set_buf(0, buf)

        if result then
            -- set the filetype to rust so that rust's syntax highlighting works
            -- :help nvim_set_option_value
            vim.api.nvim_set_option_value("filetype", "rust", { buf = 0 })

            -- Insert the result into the new buffer
            for client_id, res in pairs(result) do
                if res and res.result and res.result.expansion then
                    -- :help nvim_buf_set_lines
                    vim.api.nvim_buf_set_lines(buf, -1, -1, false, vim.split(res.result.expansion, "\n"))
                else
                    vim.api.nvim_buf_set_lines(buf, -1, -1, false, {
                        "No expansion available.",
                    })
                end
            end
        else
            vim.api.nvim_buf_set_lines(buf, -1, -1, false, {
                "Error: No result returned.",
            })
        end
    end)
end

-- Create a user command that calls this function
vim.api.nvim_create_user_command('ExpandMacro', function()
    expandMacro()
end, {})

-- Is this still required?
for _, method in ipairs({ 'textDocument/diagnostic', 'workspace/diagnostic' }) do
  local default_diagnostic_handler = vim.lsp.handlers[method]
  vim.lsp.handlers[method] = function(err, result, context, config)
    if err ~= nil and err.code == -32802 then
      return
    end
    return default_diagnostic_handler(err, result, context, config)
  end
end

require("lspconfig").rust_analyzer.setup({
  -- capabilities = capabilities,
  cmd = { "rustup", "run", "stable", "rust-analyzer" }, -- Use rustup's rust-analyzer
  settings = {
    ['rust-analyzer'] = {
      -- checkOnSave = {
      --     command = "clippy"
      -- },
    }
  },
  commands = {
    ExpandMacro = {
      expandMacro
    },
  },
})


-- Function to navigate to parent module using rust-analyzer's experimental/parentModule
-- local function goto_parent_module()
--     -- Get current position
--     local params = vim.lsp.util.make_position_params()
--
--     -- Request the parent module from rust-analyzer using the experimental feature
--     vim.lsp.buf_request(0, "experimental/parentModule", params, function(err, result, ctx, config)
--         if err then
--             vim.notify("Error finding parent module: " .. vim.inspect(err), vim.log.levels.ERROR)
--             return
--         end
--
--         if not result or vim.tbl_isempty(result) then
--             vim.notify("No parent module found", vim.log.levels.WARN)
--             return
--         end
--
--         local location = result
--         if vim.islist(result) then
--             location = result[1]
--         end
--
--         vim.notify("Navigated to parent module", vim.log.levels.INFO)
--         print(vim.inspect(location))
--         vim.lsp.util.jump_to_location(location)
--
--         -- -- Handle result - navigate to the parent module location
--         -- if result.uri and result.range then
--         --     local filepath = vim.uri_to_fname(result.uri)
--         --
--         --     -- Open the file
--         --     vim.cmd("edit " .. filepath)
--         --
--         --     -- Move cursor to location
--         --     vim.api.nvim_win_set_cursor(0, {
--         --         result.range.start.line + 1, -- LSP lines are 0-indexed, Vim is 1-indexed
--         --         result.range.start.character,
--         --     })
--         --
--         -- else
--         --     vim.notify("Invalid parent module location received", vim.log.levels.ERROR)
--         -- end
--     end)
-- end
