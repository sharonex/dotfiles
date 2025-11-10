vim.lsp.config("basedpyright", {
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { "uv", "run", "basedpyright-langserver", "--stdio" },

	settings = {
		basedpyright = {
			analysis = {
				autoSearchPaths = true,
				diagnosticMode = "workspace",
				useLibraryCodeForTypes = true,
				typeCheckingMode = "basic",
			},
		},
	},
})

vim.lsp.enable({ "basedpyright" })
