vim.lsp.config("kotlin_language_server", {
	on_attach = on_attach,
	capabilities = capabilities,
	init_options = {
		storagePath = table.concat({ vim.fn.stdpath("data") }, "nvim-data"),
	},
	settings = {
		kotlin = {
			hints = {
				typeHints = true,
				parameterHints = true,
				chainHints = true,
			},
		},
	},
})

vim.lsp.enable({ "kotlin_language_server" })
