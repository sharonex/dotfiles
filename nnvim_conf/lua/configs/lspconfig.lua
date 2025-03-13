-- Function to navigate to parent module using rust-analyzer's experimental/parentModule
local function goto_parent_module()
    -- Get current position
    local params = vim.lsp.util.make_position_params()

    -- Request the parent module from rust-analyzer using the experimental feature
    vim.lsp.buf_request(0, "experimental/parentModule", params, function(err, result, ctx, config)
        if err then
            vim.notify("Error finding parent module: " .. vim.inspect(err), vim.log.levels.ERROR)
            return
        end

        if not result or vim.tbl_isempty(result) then
            vim.notify("No parent module found", vim.log.levels.WARN)
            return
        end

        local location = result
        if vim.islist(result) then
            location = result[1]
        end

        vim.notify("Navigated to parent module", vim.log.levels.INFO)
        print(vim.inspect(location))
        vim.lsp.util.jump_to_location(location)

        -- -- Handle result - navigate to the parent module location
        -- if result.uri and result.range then
        --     local filepath = vim.uri_to_fname(result.uri)
        --
        --     -- Open the file
        --     vim.cmd("edit " .. filepath)
        --
        --     -- Move cursor to location
        --     vim.api.nvim_win_set_cursor(0, {
        --         result.range.start.line + 1, -- LSP lines are 0-indexed, Vim is 1-indexed
        --         result.range.start.character,
        --     })
        --
        -- else
        --     vim.notify("Invalid parent module location received", vim.log.levels.ERROR)
        -- end
    end)
end

-- Define command to go to parent module
vim.api.nvim_create_user_command("RustGotoParentModule", function()
    goto_parent_module()
end, {
    desc = "Navigate to parent Rust module using rust-analyzer",
})

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
    -- tsserver = {},
    -- html = { filetypes = { 'html', 'twig', 'hbs'} },
    -- eslint = {
    --     filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    -- },

    lua_ls = {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            diagnostics = { disable = { "missing-fields" }, globals = { "vim" } },
            hint = { enable = true },
        },
    },
}

local lsp_mappings = function(_)
    local nmap = function(keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end

        vim.keymap.set("n", keys, func, { desc = desc })
    end

    local vmap = function(keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end

        vim.keymap.set("v", keys, func, { desc = desc })
    end

    nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

    -- See `:help K` for why this keymap
    nmap("K", vim.lsp.buf.hover, "Hover Documentation")
    -- nmap('<A-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Lesser used LSP functionality
    nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
    nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
    nmap("<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "[W]orkspace [L]ist Folders")

    -- Rust
    nmap("<leader>re", "<Cmd>ExpandMacro<CR>", "Expand macro")

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(0, "Format", function(_)
        vim.lsp.buf.format()
    end, { desc = "Format current buffer with LSP" })
end

M.on_attach = function(client, bufnr)
    lsp_mappings()

    vim.diagnostic.config({
        severity_sort = true,
        virtual_text = true,
    })
end
-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
-- capabilities = require('blink.cmp').get_lsp_capabilities()

capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
}

-- Ensure the servers above are installed
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
    ensure_installed = vim.tbl_keys(M.servers),
})

-- nicer lsp diagnostics icons
local signs = { Error = "", Warn = "", Hint = "󰌵", Info = "" }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

mason_lspconfig.setup_handlers({
    function(server_name)
        require("lspconfig")[server_name].setup({
            capabilities = capabilities,
            on_attach = M.on_attach,
            settings = M.servers[server_name],
            filetypes = (M.servers[server_name] or {}).filetypes,
        })
    end,
})

require("lspconfig").rust_analyzer.setup({
    capabilities = capabilities,
    on_attach = M.on_attach,
    cmd = { "rustup", "run", "stable", "rust-analyzer" }, -- Use rustup's rust-analyzer
    settings = {
        ["rust-analyzer"] = {
            checkOnSave = {
                command = "check",
            },
        },
    },
    commands = {
        ExpandMacro = {
            expandMacro,
        },
    },
})

for _, method in ipairs({ "textDocument/diagnostic", "workspace/diagnostic" }) do
    local default_diagnostic_handler = vim.lsp.handlers[method]
    vim.lsp.handlers[method] = function(err, result, context, config)
        if err ~= nil and err.code == -32802 then
            return
        end
        return default_diagnostic_handler(err, result, context, config)
    end
end

require("lspconfig").ts_ls.setup({
    on_attach = function(client)
        -- Disable formatting from tsserver
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
    end,
})

return M
