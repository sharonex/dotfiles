-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
-- document existing key chains
-- require("which-key").register {
--     {
--         { "<leader>c",  group = "[C]ode" },
--         { "<leader>c_", hidden = true },
--         { "<leader>d",  group = "[D]ebug" },
--         { "<leader>d_", hidden = true },
--         { "<leader>f",  group = "[F]ind" },
--         { "<leader>f_", hidden = true },
--         { "<leader>g",  group = "[G]it" },
--         { "<leader>g_", hidden = true },
--         { "<leader>h",  group = "[H]arpoon" },
--         { "<leader>h_", hidden = true },
--         { "<leader>r",  group = "[R]ename" },
--         { "<leader>r_", hidden = true },
--         { "<leader>w",  group = "[W]orkspace" },
--         { "<leader>w_", hidden = true },
--     }
-- }

-- Allow clipboard copy paste in neovim
vim.api.nvim_set_keymap('', '<D-v>', '+p<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('!', '<D-v>', '<C-R>+', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<D-v>', '<C-R>+', { noremap = true, silent = true })
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
vim.keymap.set("n", "<leader>l", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })

vim.keymap.set("n", "<leader>tc", ":tabclose<CR>", { desc = "[T]ab [C]lose" })
vim.keymap.set("n", "<leader>tn", ":tabnext<CR>", { desc = "[T]ab [N]ext" })
vim.keymap.set("n", "<leader>tn", ":tabprev<CR>", { desc = "[T]ab [P]rev" })

-------------- Editing -------------------------------
vim.keymap.set("i", "<C-c>", "<ESC>", { desc = "" })

vim.keymap.set("n", "<C-o>", "<C-o>zz", { desc = "" })
vim.keymap.set("n", "<C-i>", "<C-i>zz", { desc = "" })

vim.keymap.set("n", "L", "$", { desc = "End of line" })
vim.keymap.set("n", "H", "^", { desc = "Start of line" })
vim.keymap.set("v", "L", "$h", { desc = "End of line" })
vim.keymap.set("v", "H", "^", { desc = "Start of line" })
-- No need to make a motion for L because all motions in upper case already go to the end of line
vim.keymap.set('o', 'L', '$', { noremap = false, silent = true })
vim.keymap.set('o', 'H', 'H<CR>', { noremap = false, silent = true })
vim.keymap.set('i', '<C-p>', '<C-o>k', { noremap = false, silent = true })
vim.keymap.set('i', '<C-n>', '<C-o>j', { noremap = false, silent = true })

vim.keymap.set("n", "<C-w>kh", "<C-w>h<C-w>q", { desc = "Kill window to the left" })
vim.keymap.set("n", "<C-w>kj", "<C-w>j<C-w>q", { desc = "Kill window below" })
vim.keymap.set("n", "<C-w>kk", "<C-w>k<C-w>q", { desc = "Kill window above" })
vim.keymap.set("n", "<C-w>kl", "<C-w>l<C-w>q", { desc = "Kill window to the right" })
vim.keymap.set("n", "==", "mb10k=20j`b", { desc = "Indent in 10 line chunk(up and down)" })

vim.keymap.set("n", "<C-c>", ":noh <CR>", { desc = "Clear highlights" })
vim.keymap.set("n", "<C-m>", "<cmd>:w<CR>", { desc = "Save file" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Keep selection when indenting
vim.keymap.set("v", "<", "<gv", { desc = "" })
vim.keymap.set("v", ">", ">gv", { desc = "" })
vim.keymap.set("v", "=gv", "=gv", { desc = "" })
