-- Tools and Utility Plugins

return {
	-- Detect tabstop and shiftwidth automatically
	"tpope/vim-sleuth",
	{
		"folke/persistence.nvim",
		lazy = false,
		opts = {},
		config = function()
			require("persistence").setup()

			-- load the session for the current directory
			vim.keymap.set("n", "<leader>qs", function()
				require("persistence").load()
			end, { desc = "Load session for current directory" })

			-- select a session to load
			vim.keymap.set("n", "<leader>qS", function()
				require("persistence").select()
			end, { desc = "Select a session to load" })

			-- load the last session
			vim.keymap.set("n", "<leader>ql", function()
				require("persistence").load({ last = true })
			end, { desc = "Load the last session" })

			-- stop Persistence => session won't be saved on exit
			vim.keymap.set("n", "<leader>qd", function()
				require("persistence").stop()
			end, { desc = "Stop persistence (don't save on exit)" })
		end,
	},
	{
		"folke/trouble.nvim",
		cmd = { "Trouble" },
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			use_diagnostic_signs = false, -- enabling this will use the signs defined in your lsp client
		},
		keys = {
			{
				"<leader>ld",
				"<cmd>Trouble diagnostics toggle pinned=false filter.buf=0<cr>",
				desc = "Document diagnostics",
			},
			{
				"<leader>lw",
				"<cmd>Trouble diagnostics toggle pinned=false<cr>",
				desc = "Workspace diagnostics",
			},
			{
				"<leader>ls",
				"<cmd>Trouble symbols toggle<cr>",
				desc = "Document [S]ymbols",
			},
			{
				"<leader>qf",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Open [Q]uick[f]ix",
			},
		},
	},
	{
		"kevinhwang91/nvim-bqf",
		ft = "qf",
	},
	{
		"stevearc/conform.nvim",
		opts = {},
		config = function()
			require("conform").setup({
				log_level = vim.log.levels.DEBUG,
				formatters_by_ft = {
					lua = { "stylua" },
					rust = { "rustfmt" },
					typescript = { "prettierd", "prettier", stop_after_first = true },
					typescriptreact = { "prettierd", "prettier", stop_after_first = true },
					javascript = { "prettierd", "prettier", stop_after_first = true },
					javascriptreact = { "prettierd", "prettier", stop_after_first = true },
					kotlin = { "ktlint" },
					java = { "google-java-format" },
				},
				formatters = {
					rustfmt = {
						command = "rustfmt",
						args = { "+nightly-2025-02-14", "--edition", "2024" },
						stdin = true,
					},
				},
			})
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*",
				callback = function(args)
					require("conform").format({ bufnr = args.buf })
				end,
			})
		end,
	},
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		config = function()
			local snacks_config = require("configs.snacks")
			require("snacks").setup(snacks_config)

			-- Setup additional keymaps after snacks is initialized
			Snacks.toggle.profiler():map("<leader>pp")
			Snacks.toggle.profiler_highlights():map("<leader>ph")
		end,
		keys = {
			{
				"<leader>,",
				function()
					Snacks.picker.buffers()
				end,
				desc = "Buffers",
			},
			{
				"<leader>:",
				function()
					Snacks.picker.command_history()
				end,
				desc = "Command History",
			},
			{
				"<leader>u",
				function()
					Snacks.picker.undo()
				end,
				desc = "Undo",
			},
			-- find
			{
				"<leader>fc",
				function()
					Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
				end,
				desc = "Find Config File",
			},
			{
				"<leader>f",
				function()
					Snacks.picker.git_files()
				end,
				desc = "Find Git Files",
			},
			{
				"<leader>sx",
				function()
					Snacks.picker.diagnostics()
				end,
				desc = "Diagnostics",
			},
			{
				"<leader>sr",
				function()
					Snacks.picker.recent()
				end,
				desc = "Recent",
			},
			-- Grep
			{
				"<leader>/",
				function()
					Snacks.picker.lines()
				end,
				desc = "Buffer Lines",
			},
			{
				"<leader>sp",
				function()
					Snacks.picker.grep()
				end,
				desc = "Grep",
			},
			{
				"<leader>sP",
				function()
					Snacks.picker.grep_word()
				end,
				desc = "Visual selection or word",
				mode = { "n", "x", "v" },
			},
			-- search
			{
				"<leader>sg",
				function()
					Snacks.picker.git_diff()
				end,
				desc = "Git Diff",
			},
			{
				"<leader>sc",
				function()
					Snacks.picker.command_history()
				end,
				desc = "Command History",
			},
			{
				"<leader>sC",
				function()
					Snacks.picker.commands()
				end,
				desc = "Commands",
			},
			{
				"<leader>sD",
				function()
					Snacks.picker.diagnostics()
				end,
				desc = "All Diagnostics",
			},
			{
				"<leader>sh",
				function()
					Snacks.picker.help()
				end,
				desc = "Help Pages",
			},
			{
				"<leader>sk",
				function()
					Snacks.picker.keymaps()
				end,
				desc = "Keymaps",
			},
			{
				"<leader>sl",
				function()
					Snacks.picker.resume()
				end,
				desc = "Resume",
			},
			{
				"<leader>sq",
				function()
					Snacks.picker.qflist()
				end,
				desc = "Quickfix List",
			},
			{
				"<leader>sb",
				function()
					Snacks.picker.git_branches()
				end,
				desc = "Search Branches",
			},
			-- LSP
			{
				"gd",
				function()
					Snacks.picker.lsp_definitions()
				end,
				desc = "Goto Definition",
			},
			{
				"grr",
				function()
					Snacks.picker.lsp_references()
				end,
				nowait = true,
				desc = "References",
			},
			{
				"gri",
				function()
					Snacks.picker.lsp_implementations()
				end,
				desc = "Goto Implementation",
			},
			{
				"<leader>D",
				function()
					Snacks.picker.lsp_type_definitions()
				end,
				desc = "Goto T[y]pe Definition",
			},
			{
				"<leader>sd",
				function()
					Snacks.picker.lsp_symbols()
				end,
				desc = "LSP [D]ocument Symbols",
			},
			{
				"<leader>ss",
				function()
					Snacks.picker.lsp_workspace_symbols()
				end,
				desc = "LSP Workspace Symbols",
			},
			-- Git
			{
				"<leader>go",
				function()
					Snacks.gitbrowse.open()
				end,
				desc = "Git open in browser",
			},
		},
	},
}
