-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
-- document existing key chains
require("which-key").register {
    ["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
    ["<leader>d"] = { name = "[D]ebug", _ = "which_key_ignore" },
    ["<leader>g"] = { name = "[G]it", _ = "which_key_ignore" },
    ["<leader>h"] = { name = "[H]arpoon", _ = "which_key_ignore" },
    ["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
    ["<leader>f"] = { name = "[F]ind", _ = "which_key_ignore" },
    ["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" }
}

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set("n", "<C-w>v", "<C-w>v<C-w>l")
vim.keymap.set("n", "<C-w>s", "<C-w>s<C-w>j")
-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- See `:help telescope.builtin`
vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
-- vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set(
    "n",
    "<leader>/",
    function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        require("telescope.builtin").current_buffer_fuzzy_find(
            require("telescope.themes").get_dropdown {
                winblend = 10,
                previewer = false
            }
        )
    end,
    { desc = "[/] Fuzzily search in current buffer" }
)

local egrepify_with_text = function()
    -- if in visual mode
    if vim.fn.mode() == "v" then
        -- yank the highlighted text into register z
        vim.cmd('normal! "zy')

        -- get the content of register z
        local search_term = vim.fn.getreg("z")
        require("telescope").extensions.egrepify.egrepify({ default_text = search_term })
    else
        -- yank current word under cursor
        local current_word =
            require("telescope").extensions.egrepify.egrepify({ default_text = vim.fn.expand("<cword>") })
    end
end

-------------- Telescope ----------------------------------
vim.keymap.set("n", "<leader>f", require("telescope.builtin").git_files, { desc = "[F]ind (Git) Files" })
vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
-- vim.keymap.set("n", "<leader>sr", require("telescope").extensions.project.project, { desc = "[S]earch [R]epo" })
vim.keymap.set("n", "<leader>sl", require("telescope.builtin").resume, { desc = "[S]earch [L]ast again" })
vim.keymap.set("n", "<leader>sp", "<cmd> Telescope egrepify<CR>", { desc = "Find in files" })
vim.keymap.set({ "n", "v" }, "<leader>sP", egrepify_with_text, { desc = "Find current word in files" })
vim.keymap.set("v", "<leader>sp", egrepify_with_text, { desc = "Find selection in files" })
vim.keymap.set({ "n", "v" }, "<leader>sT", require("telescope.builtin").live_grep,
    { desc = "Find current word in files" })
vim.keymap.set("v", "<leader>sp", egrepify_with_text, { desc = "Find selection in files" })
-- vim.keymap.set("n", "<leader>ss", "<cmd> Telescope current_buffer_fuzzy_find <CR>", { desc = "Find in current file" })
vim.keymap.set("n", "<leader>sc", "<cmd> Telescope commands <CR>", { desc = "Find vim commands" })
vim.keymap.set("n", "<leader>sk", "<cmd> Telescope keymaps <CR>", { desc = "Look up key mappings" })
vim.keymap.set({ "n", "v" }, "<leader>p", function() require("telescope").extensions.yank_history.yank_history({}) end,
    { desc = "Open yank History" })

-- vim.keymap.set(
--     "",
--     "<Leader>lq",
--     require("lsp_lines").toggle,
--     { desc = "Toggle lsp_lines" }
-- )

-------------------------------------------------------

-- Tmux window navigation
vim.keymap.set('n', '<A-h>', require('smart-splits').resize_left)
vim.keymap.set('n', '<A-j>', require('smart-splits').resize_down)
vim.keymap.set('n', '<A-k>', require('smart-splits').resize_up)
vim.keymap.set('n', '<A-l>', require('smart-splits').resize_right)
-- moving between splits
vim.keymap.set('n', '<C-h>', require('smart-splits').move_cursor_left)
vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_down)
vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_up)
vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_right)
-- swapping buffers between windows
vim.keymap.set('n', '<leader><leader>h', require('smart-splits').swap_buf_left)
vim.keymap.set('n', '<leader><leader>j', require('smart-splits').swap_buf_down)
vim.keymap.set('n', '<leader><leader>k', require('smart-splits').swap_buf_up)
vim.keymap.set('n', '<leader><leader>l', require('smart-splits').swap_buf_right)


-- Setup neovim lua configuration

vim.keymap.set("n", "<C-q>", ":NvimTreeFindFileToggle<CR>", { desc = "Toggle nvim tree" })
vim.keymap.set("n", "<leader>tc", ":tabclose<CR>", { desc = "[T]ab [C]lose" })
vim.keymap.set("n", "<leader>tn", ":tabnext<CR>", { desc = "[T]ab [N]ext" })
vim.keymap.set("n", "<leader>tn", ":tabprev<CR>", { desc = "[T]ab [P]rev" })
vim.keymap.set("n", "<C-t>", ":ToggleTerm<CR>", { desc = "Toggle terminal" })

-------------- Editing -------------------------------
-- Gnu line shortcuts in insert mode
-- vim.keymap.set({ "n", "x" }, "y", "<Plug>(YankyYank)")

vim.keymap.set("i", "<C-c>", "<ESC>", { desc = "" })

vim.keymap.set("n", "<C-o>", "<C-o>zz", { desc = "" })
vim.keymap.set("n", "<C-i>", "<C-i>zz", { desc = "" })

-- vim.keymap.set("v", "p", '"_dP', { desc = "Paste without yanking" })

vim.keymap.set("n", "L", "$", { desc = "End of line" })
vim.keymap.set("n", "H", "^", { desc = "Start of line" })
vim.keymap.set("v", "L", "$h", { desc = "End of line" })
vim.keymap.set("v", "H", "^", { desc = "Start of line" })
-- No need to make a motion for L because all motions in upper case already go to the end of line
vim.keymap.set('o', 'L', '$', { noremap = false, silent = true })
vim.keymap.set('o', 'H', 'H<CR>', { noremap = false, silent = true })
vim.keymap.set('i', '<C-p>', '<C-o>k', { noremap = false, silent = true })
vim.keymap.set('i', '<C-n>', '<C-o>j', { noremap = false, silent = true })


-- vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Page Down" })
-- vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Page Up" })

vim.keymap.set("n", "<C-w>kh", "<C-w>h<C-w>q", { desc = "Kill window to the left" })
vim.keymap.set("n", "<C-w>kj", "<C-w>j<C-w>q", { desc = "Kill window below" })
vim.keymap.set("n", "<C-w>kk", "<C-w>k<C-w>q", { desc = "Kill window above" })
vim.keymap.set("n", "<C-w>kl", "<C-w>l<C-w>q", { desc = "Kill window to the right" })
vim.keymap.set("n", "==", "mb10k=20j`b", { desc = "Indent in 10 line chunk(up and down)" })

-- motions
vim.keymap.set({ "o", "x" }, 'ii', ":lua require('configs/indentation_object')(false)<CR>",
    { noremap = true, silent = true })
vim.keymap.set({ "o", "x" }, 'ai', ":lua require('configs/indentation_object')(true)<CR>",
    { noremap = true, silent = true })

-- Folds
-- vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
-- vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
-- vim.keymap.set('n', '-', "zc", { desc = "Close fold" })
-- vim.keymap.set('n', '+', "zo", { desc = "Open fold" })
-- vim.keymap.set('n', 'K', function()
--     local winid = require('ufo').peekFoldedLinesUnderCursor()
--     if not winid then
--         -- choose one of coc.nvim and nvim lsp
--         vim.fn.CocActionAsync('definitionHover') -- coc.nvim
--         vim.lsp.buf.hover()
--     end
-- end)

vim.keymap.set("n", "cgw", "*Ncgn", { desc = "Repeatably change current word" })

vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<CR><cmd>UndotreeFocus<CR>", { desc = "Toggle UndoTree" })
vim.keymap.set("n", "<C-c>", ":noh <CR>", { desc = "Clear highlights" })
vim.keymap.set("n", "<C-m>", "<cmd>:w<CR>", { desc = "Save file" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Keep selection when indenting
vim.keymap.set("v", "<", "<gv", { desc = "" })
vim.keymap.set("v", ">", ">gv", { desc = "" })
vim.keymap.set("v", "=gv", "=gv", { desc = "" })

-- Smart visual expansion
vim.keymap.set("v", "v", "<Plug>(expand_region_expand)", { desc = "Expand selection region" })
-------------------------------------------------------

-- Lua
vim.keymap.set("n", "<leader>xx", "<cmd>source % <CR>", { desc = "execute current file" })

-- Exchange
vim.keymap.set("n", "gx", "<cmd>lua require('substitute.exchange').operator()<cr>", { desc = "" })
vim.keymap.set("n", "gxc", "<cmd>lua require('substitute.exchange').cancel()<cr>", { desc = "" })
vim.keymap.set("v", "gx", "<cmd>lua require('substitute.exchange').visual()<cr>", { desc = "" })
vim.keymap.set("n", "gp", "<cmd>lua require('substitute').operator()<cr>", { desc = "" })
vim.keymap.set("n", "gP", "<cmd>lua require('substitute').eol()<cr>", { desc = "" })

-- Rust
-- vim.keymap.set("n", "<leader>re", "<cmd>RustExpandMacro<CR>", { desc = "[R]ust expand macro" })
-- vim.keymap.set("n", "<leader>rc", "<cmd>RustOpenCargo<CR>", { desc = "[R]ust open cargo" })
-- vim.keymap.set("n", "<leader>rp", "<cmd>RustParentModule<CR>", { desc = "[R]ust open parent module" })

vim.keymap.set("n", "<leader>re", "<cmd>RustLsp expandMacro<CR>", { desc = "[R]ust expand macro" })
vim.keymap.set("n", "<leader>rc", "<cmd>RustLsp openCargo<CR>", { desc = "[R]ust open cargo" })
vim.keymap.set("n", "<leader>rp", "<cmd>RustLsp parentModule<CR>", { desc = "[R]ust open parent module" })
vim.keymap.set("n", "<leader>rr", "<cmd>RustLsp reloadWorkspace<CR>", { desc = "[R]ust [R]estart" })
vim.keymap.set("n", "<leader>rd", "<cmd>RustLsp flyCheck <CR>", { desc = "[R]ust [D]iagnostics" })
vim.keymap.set("n", "<leader>rf", "<cmd>!cargo +nightly fmt <CR>", { desc = "[R]ust [F]ormat" })
vim.keymap.set("n", "<leader>rx", "<cmd>RustLsp flyCheck clear <CR>", { desc = "[R]ust [F]lycheck [X]remove" })
vim.keymap.set("n", "<leader>rs", "<cmd>lua vim.lsp.inlay_hint.enable() <CR>",
    { desc = "[R]ust [S]how inlay hints" })

-- vim.keymap.set("n", "<leader>rdc", function()
--     vim.g.rustaceanvim.server.default_settings['rust-analyzer'].checkOnSave.command = "check"
-- end, { desc = "[R]ust [D]iagnostics [C]heck" })
--
-- vim.keymap.set("n", "<leader>rdp", function()
--     vim.g.rustaceanvim.server.default_settings['rust-analyzer'].checkOnSave.command = "clippy"
-- end, { desc = "[R]ust [D]iagnostics Cli[p]py" })
-------------- Git ----------------------------------
vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { desc = "Opens Lazy[G]it" })
vim.keymap.set("n", "<leader>gB", "<cmd> Git blame<CR>", { desc = "Run [G]it [B]lame on file" })
vim.keymap.set("n", "<leader>gb", "<cmd> Gitsigns toggle_current_line_blame<CR>", { desc = "[G]it [B]lame on each line" })
-- vim.keymap.set("n", "<leader>gas", ":AdvancedGitSearch search_log_content<CR>", { desc = "Search git log for something" })
vim.keymap.set({ "n", "v" }, "<leader>gs", ":Gitsigns stage_hunk<CR>", { desc = "[G]it [S]tage hunk" })
vim.keymap.set({ "n", "v" }, "<leader>gu", ":Gitsigns reset_hunk<CR>", { desc = "[G]it [U]ndo hunk" })
vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { desc = "[G]it [p]op hunk diff" })
vim.keymap.set("n", "<leader>g[", ":GitMediate<CR>", { desc = "Run git mediate conflict resolver" })
vim.keymap.set("n", "<leader>g]", ":GitMediateTerm<CR>",
    { desc = "Run git mediate conflict resolver in terminal mode(with colors)" })
vim.keymap.set("n", "<leader>gf", ":Git<CR>/taged<CR>:noh<CR>j", { desc = "[G]it [F]ugitive" })
vim.keymap.set("n", "<leader>gl", ":Git log <CR>", { desc = "[G]it fugitive [L]og" })
vim.keymap.set("n", "<leader>grc", ":Git rebase --continue<CR>", { desc = "[G]it [R]ebase [C]ontinue" })
vim.keymap.set("n", "<leader>gra", ":Git rebase --abort<CR>", { desc = "[G]it [R]ebase [A]ontinue" })
vim.keymap.set("n", "<leader>gn", ":Neogit kind=vsplit <CR>", { desc = "[G]it [N]eogit" })
vim.keymap.set("n", "<leader>gd", ":DiffviewOpen<CR>", { desc = "[G]it [D]iff" })

vim.keymap.set({ "n", "v" }, "<leader>gh", ":DiffviewFileHistory %<CR>", { desc = "[G]it [H]istory" })

vim.keymap.set("n", "]g", ": Gitsigns next_hunk<CR>", { desc = "next git hunk" })
vim.keymap.set("n", "[g", ": Gitsigns prev_hunk<CR>", { desc = "prev git hunk" })
-----------------------------------------------------

-------------- LSP ----------------------------------
local lsp_mappings = function(_)
    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { desc = desc })
    end

    local vmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end

        vim.keymap.set('v', keys, func, { desc = desc })
    end

    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap("<leader>ca", require("actions-preview").code_actions, '[C]ode [A]ction')
    vmap("<leader>ca", require("actions-preview").code_actions, '[C]ode [A]ction')

    nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
    nmap('gr', "<cmd> FzfLua lsp_references<CR>", '[G]oto [R]eferences')
    nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
    nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
    nmap('<leader>sd', require('telescope.builtin').lsp_document_symbols, '[S]earch [D]ocument')
    nmap('<leader>ss', '<cmd> FzfLua lsp_live_workspace_symbols<CR>', '[S]earch [S]ymbols')
    nmap('<leader>st', "<cmd> FzfLua tags_live_grep<CR>", '[S]earch [T]ags')

    -- See `:help K` for why this keymap
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    -- nmap('<A-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Lesser used LSP functionality
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    nmap('<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(0, 'Format', function(_)
        vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })
end

lsp_mappings()

-- Harpoon 2
-- local harpoon = require("harpoon")
-- vim.keymap.set("n", "<leader>ha", function() harpoon:list():append() end)
-- vim.keymap.set("n", "<leader>hm", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
--
-- vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end)
-- vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end)
-- vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end)
-- vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end)

vim.keymap.set("n", "<leader>ha", function() require("harpoon.mark").add_file() end)
vim.keymap.set("n", "<leader>hm", function() require("harpoon.ui").toggle_quick_menu() end)

vim.keymap.set("n", "<leader>1", function() require("harpoon.ui").nav_file(1) end)
vim.keymap.set("n", "<leader>2", function() require("harpoon.ui").nav_file(2) end)
vim.keymap.set("n", "<leader>3", function() require("harpoon.ui").nav_file(3) end)
vim.keymap.set("n", "<leader>4", function() require("harpoon.ui").nav_file(4) end)
vim.keymap.set("n", "<leader>5", function() require("harpoon.ui").nav_file(5) end)
vim.keymap.set("n", "<leader>6", function() require("harpoon.ui").nav_file(6) end)

-- trouble
vim.keymap.set("n", "<leader>ll", "<cmd> lua vim.diagnostic.open_float({scope=\"line\"}) <cr>",
    { desc = "Show line diagnostics" })
vim.keymap.set("n", "<leader>lc", "<cmd> lua vim.diagnostic.open_float({scope=\"cursor\"}) <cr>",
    { desc = "Show line diagnostics" })
vim.keymap.set("n", "<leader>ld", "<cmd> Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Document diagnostics" })
vim.keymap.set("n", "<leader>lw", "<cmd> Trouble diagnostics toggle<cr>", { desc = "Workspace diagnostics" })
vim.keymap.set("n", "<leader>qf", "<cmd> Trouble qflist toggle<cr>", { desc = " open [Q]uick[f]ix" })

-- Oil
vim.keymap.set("n", "|", "<CMD>Oil<CR>", { desc = "Open parent directory" })

vim.keymap.set("n", "<leader>tr", "<cmd>Neotest run<CR>", { desc = "Run current test" })

vim.keymap.set("n", "<leader>to", "<cmd>Neotest output-panel<CR>", { desc = "Open test output" })
vim.keymap.set("n", "<leader>ts", "<cmd>Neotest summary<CR>", { desc = "Open test output" })

vim.keymap.set("n", "<leader>tg",
    function()
        local neotest = require("neotest")
        neotest.run.get_last_run()
        neotest.run.run()
    end,
    { desc = "Run last test" }
)
-- Debugging
vim.keymap.set("n", "<leader>dt", "<cmd>DapToggleBreakpoint<CR>", { desc = "[D]ebug [T]oggle Breakpoint" })
vim.keymap.set("n", "<leader>do", "<cmd>DapStepOver<CR>", { desc = "[D]ebug [O]ver" })
vim.keymap.set("n", "<leader>di", "<cmd>DapStepInto<CR>", { desc = "[D]ebug [I]nto" })
vim.keymap.set("n", "<leader>dc", "<cmd>DapContinue<CR>", { desc = "[D]ebug [C]ontinue" })
vim.keymap.set("n", "<leader>dx", "<cmd>DapTerminate<CR>", { desc = "[D]ebug [X]it" })
