vim.lsp.config("ts-ls", {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	on_attach = function(client)
		-- Disable formatting from tsserver
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
})

vim.lsp.enable({ "ts-ls" })
