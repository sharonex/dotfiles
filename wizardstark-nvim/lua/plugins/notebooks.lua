return {
	{
		"benlubas/molten-nvim",
		ft = { "ipynb", "markdown" },
		version = "^1.0.0",
		build = ":UpdateRemotePlugins",
		dependencies = {
			"quarto-dev/quarto-nvim",
			"GCBallesteros/jupytext.nvim",
		},
		config = function()
			require("config.notebooks")
		end,
	},
	{
		"GCBallesteros/jupytext.nvim",
		event = "UiEnter",
		opts = {
			style = "markdown",
			output_extension = "md",
			force_ft = "markdown",
		},
	},
	{
		"quarto-dev/quarto-nvim",
		ft = { "quarto", "markdown" },
		dev = false,
		dependencies = {
			"jmbuhr/otter.nvim",
		},
		opts = {
			debug = true,
			codeRunner = {
				enabled = true,
				default_method = "molten",
			},
		},
	},
}
