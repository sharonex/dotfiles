-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
-- document existing key chains
require("which-key").register {
    ["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
    ["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
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

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- See `:help telescope.builtin`
vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
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
vim.keymap.set("n", "<leader>ff", require("telescope.builtin").git_files, { desc = "[F]ind [F]iles" })
vim.keymap.set("n", "<leader>sf", require("telescope.builtin").git_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sl", require("telescope.builtin").resume, { desc = "[S]earch [L]ast again" })
vim.keymap.set("n", "<leader>sp", "<cmd> Telescope egrepify<CR>", { desc = "Find in files" })
vim.keymap.set({ "n", "v" }, "<leader>sP", egrepify_with_text, { desc = "Find current word in files" })
vim.keymap.set("v", "<leader>sp", egrepify_with_text, { desc = "Find selection in files" })
vim.keymap.set("n", "<leader>ss", "<cmd> Telescope current_buffer_fuzzy_find <CR>", { desc = "Find in current file" })
vim.keymap.set("n", "<leader>sc", "<cmd> Telescope commands <CR>", { desc = "Find vim commands" })
vim.keymap.set("n", "<leader>sk", "<cmd> Telescope keymaps <CR>", { desc = "Look up key mappings" })
vim.keymap.set({ "n", "v" }, "<leader>p", function() require("telescope").extensions.yank_history.yank_history({}) end,
    { desc = "Open yank History" })

vim.keymap.set(
    "n",
    "<leader>ss",
    "<cmd> Telescope lsp_dynamic_workspace_symbols <CR>",
    { desc = "Search workspace symbols" }
)
-------------------------------------------------------

-- Tmux window navigation

vim.keymap.set("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>", { desc = "window left" })
vim.keymap.set("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>", { desc = "window right" })
vim.keymap.set("n", "<C-j>", "<cmd> TmuxNavigateDown<CR>", { desc = "window down" })
vim.keymap.set("n", "<C-k>", "<cmd> TmuxNavigateUp<CR>", { desc = "window up" })

-- Setup neovim lua configuration

vim.keymap.set("n", "<C-t>", ":NvimTreeFindFileToggle<CR>", { desc = "Toggle nvim tree" })

-------------- Editing -------------------------------
-- Gnu line shortcuts in insert mode
vim.keymap.set({ "n", "x" }, "y", "<Plug>(YankyYank)")

vim.keymap.set("i", "<C-c>", "<ESC>", { desc = "" })

vim.keymap.set("n", "<C-o>", "<C-o>zz", { desc = "" })
vim.keymap.set("n", "<C-i>", "<C-i>zz", { desc = "" })

vim.keymap.set("n", "<A-S-Left>", "4<C-W>>", { desc = "Resize to the left" })
vim.keymap.set("n", "<A-S-Right>", "4<C-W><", { desc = "Resize to the right" })
vim.keymap.set("n", "<A-S-Up>", "4<C-W>+", { desc = "Resize to up" })
vim.keymap.set("n", "<A-S-Down>", "4<C-W>-", { desc = "Resize to down" })
vim.keymap.set("v", "p", '"_dP', { desc = "Paste without yanking" })

vim.keymap.set("n", "J", "mpJx`p", { desc = "Join lines without spaces" })

vim.keymap.set("n", "L", "$", { desc = "End of line" })
vim.keymap.set("n", "H", "^", { desc = "Start of line" })
vim.keymap.set("v", "L", "$h", { desc = "End of line" })
vim.keymap.set("v", "H", "^", { desc = "Start of line" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Page Down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Page Up" })

vim.keymap.set("n", "<C-w>kh", "<C-w>h<C-w>q", { desc = "Kill window to the left" })
vim.keymap.set("n", "<C-w>kj", "<C-w>j<C-w>q", { desc = "Kill window below" })
vim.keymap.set("n", "<C-w>kk", "<C-w>k<C-w>q", { desc = "Kill window above" })
vim.keymap.set("n", "<C-w>kl", "<C-w>l<C-w>q", { desc = "Kill window to the right" })
vim.keymap.set("n", "==", "mb10k=20j`b", { desc = "Indent in 10 line chunk(up and down)" })

vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', {
    desc = "Toggle [S]pectre"
})

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

-- Code actions
vim.keymap.set({ "n", "v" }, "<leader>ca", "<cmd>CodeActionMenu<cr>", { desc = "Open code actions" })

-- Rust
vim.keymap.set("n", "<leader>re", "<cmd>RustExpandMacro<CR>", { desc = "[R]ust expand macro" })
vim.keymap.set("n", "<leader>rc", "<cmd>RustOpenCargo<CR>", { desc = "[R]ust open cargo" })
vim.keymap.set("n", "<leader>rp", "<cmd>RustParentModule<CR>", { desc = "[R]ust open parent module" })


-------------- Git ----------------------------------
vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { desc = "Opens Lazy[G]it" })
vim.keymap.set("n", "<leader>gB", "<cmd> Git blame<CR>", { desc = "Run [G]it [B]lame on file" })
vim.keymap.set("n", "<leader>gb", "<cmd> Gitsigns toggle_current_line_blame<CR>", { desc = "[G]it [B]lame on each line" })
vim.keymap.set(
    "n",
    "<leader>gaf",
    ":AdvancedGitSearch diff_commit_file<CR>",
    { desc = "Show last commits that changed current file" }
)
vim.keymap.set("n", "<leader>gas", ":AdvancedGitSearch search_log_content<CR>", { desc = "Search git log for something" })
vim.keymap.set({ "n", "v" }, "<leader>gs", ":Gitsigns stage_hunk<CR>", { desc = "[G]it [S]tage hunk" })
vim.keymap.set("n", "<leader>gr", ":Gitsigns reset_hunk<CR>", { desc = "[G]it [R]eset hunk" })
vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { desc = "[G]it [p]op hunk diff" })
vim.keymap.set("n", "<leader>g[", ":GitMediate<CR>", { desc = "Run git mediate conflict resolver" })
vim.keymap.set("n", "<leader>gf", ":Git<CR>/taged<CR>:noh<CR>j", { desc = "[G]it [F]ugitive" })
vim.keymap.set("n", "<leader>gl", ":Git log<CR>", { desc = "[G]it fugitive [L]og" })

vim.keymap.set(
    "v",
    "<leader>gal",
    ":'<,'>AdvancedGitSearch diff_commit_line<CR>",
    { desc = "Show last commits that changed highlighted lines" }
)
vim.keymap.set("n", "]g", ": Gitsigns next_hunk<CR>", { desc = "next git hunk" })
vim.keymap.set("n", "[g", ": Gitsigns prev_hunk<CR>", { desc = "prev git hunk" })
-------------------------------------------------------

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

-- trouble
vim.keymap.set("n", "<leader>ll", "<cmd> lua vim.diagnostic.open_float({scope=\"line\"}) <cr>",
    { desc = "Show line diagnostics" })
vim.keymap.set("n", "<leader>lc", "<cmd> lua vim.diagnostic.open_float({scope=\"cursor\"}) <cr>",
    { desc = "Show line diagnostics" })
vim.keymap.set("n", "<leader>ld", "<cmd> TroubleToggle document_diagnostics<cr>", { desc = "Document diagnostics" })
vim.keymap.set("n", "<leader>lw", "<cmd> TroubleToggle workspace_diagnostics<cr>", { desc = "Workspace diagnostics" })
vim.keymap.set("n", "<leader>qf", "<cmd> TroubleToggle quickfix<cr>", { desc = " open [Q]uick[f]ix" })

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
