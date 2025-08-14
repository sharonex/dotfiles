-- nicer lsp diagnostics icons
vim.diagnostic.config({
	severity_sort = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.HINT] = "󰌵",
			[vim.diagnostic.severity.INFO] = "",
		},
	},
})

require("configs.lsp.lua_ls")
require("configs.lsp.rust-analyzer")
require("configs.lsp.typescript-language-server")
