-- Neovim Configuration
-- Load core configuration
require("core.options")
require("core.autocmds")
require("core.keymaps")

-- Load plugins
require("plugins")

-- Load LSP configuration
require("configs.lspconfig")
