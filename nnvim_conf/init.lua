-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.path:append("/opt/homebrew/bin/")
vim.cmd([[
    let g:neovide_input_macos_option_key_is_meta = 'only_left'
    " Allow copy paste in neovim
    let g:neovide_input_use_logo = 1
    set statusline=%f
]])
require("plugins")

-- Disable automatic commenting on newline
vim.cmd("autocmd BufEnter * set formatoptions-=cro")
vim.cmd("autocmd BufEnter * setlocal formatoptions-=cro")

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = "unnamedplus"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

vim.o.tabstop = 4      -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4  -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4   -- Number of spaces inserted when indenting

vim.opt.swapfile = false

vim.wo.relativenumber = true

-- [[ Basic Keymaps ]]
-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = "*",
})

-- Enable format on save
vim.cmd([[autocmd BufWritePre * lua vim.lsp.buf.format()]])

vim.g.rust_recommended_style = false

require("mappings")
require("configs/abbrev")

vim.opt.fillchars:append({ diff = "╱" })
vim.o.foldmethod = "manual"
vim.o.foldcolumn = "0"
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.o.diffopt = "internal,filler,closeoff,linematch:60"
