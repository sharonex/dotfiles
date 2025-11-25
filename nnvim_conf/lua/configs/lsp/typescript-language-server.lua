vim.lsp.config("ts-ls", {
	on_attach = function(client)
		-- Disable formatting from tsserver
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
})

vim.lsp.enable({ "ts-ls" })
