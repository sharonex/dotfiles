-- Git Integration Plugins

return {
	{
		-- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {
			sign_priority = 100,
			on_attach = function(bufnr)
				-- don't override the built-in and fugitive keymaps
				local gs = package.loaded.gitsigns
				vim.keymap.set({ "n", "v" }, "]c", function()
					if vim.wo.diff then
						return "]c"
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, buffer = bufnr, desc = "Jump to next hunk" })
				vim.keymap.set({ "n", "v" }, "[c", function()
					if vim.wo.diff then
						return "[c"
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, buffer = bufnr, desc = "Jump to previous hunk" })

				vim.keymap.set({ "n", "v" }, "<leader>gs", ":Gitsigns stage_hunk<CR>", { desc = "[G]it [S]tage hunk" })
				vim.keymap.set({ "n", "v" }, "<leader>gu", ":Gitsigns reset_hunk<CR>", { desc = "[G]it [U]ndo hunk" })
				vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { desc = "[G]it [p]op hunk diff" })
				vim.keymap.set("n", "]g", function()
					gs.next_hunk()
				end, { desc = "next git hunk" })
				vim.keymap.set("n", "[g", function()
					gs.prev_hunk()
				end, { desc = "prev git hunk" })
				vim.keymap.set("n", "<leader>gd", function()
					require("gitsigns").diffthis("~")
				end, { desc = "prev git hunk" })
			end,
		},
	},
	{
		"echasnovski/mini.diff",
		event = "UiEnter",
		version = false,
		opts = {
			view = {
				style = "sign",
				signs = {
					add = "┃",
					change = "┃",
					delete = "_",
				},
			},
			delay = {
				text_change = 50,
			},
			mappings = {
				apply = "",
				reset = "",
				textobject = "",
				goto_first = "",
				goto_prev = "",
				goto_next = "",
				goto_last = "",
			},
			options = {
				wrap_goto = true,
			},
		},
	},
	{
		"tpope/vim-fugitive",
		event = "VeryLazy",
		config = function()
			vim.keymap.set("n", "<leader>gB", "<cmd> Git blame<CR>", { desc = "Run [G]it [B]lame on file" })
			vim.keymap.set("n", "<leader>gf", ":Git<CR>/taged<CR>:noh<CR>j", { desc = "[G]it [F]ugitive" })
			vim.keymap.set("n", "<leader>gl", ":Git log<CR>", { desc = "[G]it [L]og" })
			vim.keymap.set("n", "<leader>ga", ":Git commit --amend", { desc = "[G]it [A]mend" })
			vim.keymap.set("n", "<leader>gc", ':Git commit -m "', { desc = "[G]it [C]ommit" })
			vim.keymap.set("n", "<leader>grm", ":Git pull origin main --rebase<CR>", { desc = "[G]it [R]ebase [M]ain" })
			vim.keymap.set("n", "<leader>grc", ":Git rebase --continue<CR>", { desc = "[G]it [R]ebase [C]ontinue" })
			vim.keymap.set("n", "<leader>gra", ":Git rebase --abort<CR>", { desc = "[G]it [R]ebase [A]bort" })
		end,
	},
	{
		"sindrets/diffview.nvim",
		event = "VeryLazy",
		config = function()
			vim.keymap.set("n", "<leader>gv", "<cmd>DiffviewOpen<CR>", { desc = "[G]it Diff[V]iew Open" })
			vim.keymap.set("n", "<leader>gx", "<cmd>DiffviewClose<CR>", { desc = "[G]it Diffview E[X]it" })
			vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", { desc = "[G]it File [H]istory" })
		end,
	},
}
