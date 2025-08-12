-- Core Neovim Options
-- Set <space> as the leader key
-- NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Path configuration
vim.opt.path:append("/opt/homebrew/bin/")

-- Neovide configuration
vim.cmd([[
    let g:neovide_input_macos_option_key_is_meta = 'only_left'
    " Allow copy paste in neovim
    let g:neovide_input_use_logo = 1
    set statusline=%f
]])

-- Search and highlight options
vim.o.hlsearch = false

-- Line numbers
vim.wo.number = true
vim.wo.relativenumber = true

-- Mouse support
vim.o.mouse = "a"

-- Clipboard synchronization
-- Remove this option if you want your OS clipboard to remain independent.
vim.o.clipboard = "unnamedplus"

-- Indentation
vim.o.breakindent = true

-- Undo history
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

-- Terminal colors
vim.o.termguicolors = true

-- Tab and indentation settings
vim.o.tabstop = 4 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4 -- Number of spaces inserted when indenting

-- Disable swap files
vim.opt.swapfile = false

-- Language-specific settings
vim.g.rust_recommended_style = false

-- Folding configuration
vim.opt.fillchars:append({ diff = "╱" })
vim.o.foldmethod = "manual"
vim.o.foldcolumn = "0"
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Diff configuration
vim.o.diffopt = "internal,filler,closeoff,linematch:60"

-- Runtime path
vim.opt.runtimepath:append(",~/.config/nvim/lua")

vim.opt.diffopt:append("iwhite")

