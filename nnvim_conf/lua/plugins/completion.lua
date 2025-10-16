-- Completion and LSP Plugins

return {
	{
		"saghen/blink.cmp",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			"saghen/blink.compat",
			"xzbdmw/colorful-menu.nvim",
		},
		version = "v1.*",
		config = function()
			require("configs.blink_cmp")
		end,
	},

	-- {
	-- 	'saghen/blink.cmp',
	-- 	-- use a release tag to download pre-built binaries
	-- 	version = '1.*',
	--
	-- 	---@module 'blink.cmp'
	-- 	---@type blink.cmp.Config
	-- 	opts = {
	-- 		-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
	-- 		-- 'super-tab' for mappings similar to vscode (tab to accept)
	-- 		-- 'enter' for enter to accept
	-- 		-- 'none' for no mappings
	-- 		--
	-- 		-- All presets have the following mappings:
	-- 		-- C-space: Open menu or open docs if already open
	-- 		-- C-n/C-p or Up/Down: Select next/previous item
	-- 		-- C-e: Hide menu
	-- 		-- C-k: Toggle signature help (if signature.enabled = true)
	-- 		--
	-- 		-- See :h blink-cmp-config-keymap for defining your own keymap
	-- 		keymap = { preset = 'default' },
	--
	-- 		appearance = {
	-- 			-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
	-- 			-- Adjusts spacing to ensure icons are aligned
	-- 			nerd_font_variant = 'mono'
	-- 		},
	--
	-- 		-- (Default) Only show the documentation popup when manually triggered
	-- 		completion = { documentation = { auto_show = false } },
	--
	-- 		-- Default list of enabled providers defined so that you can extend it
	-- 		-- elsewhere in your config, without redefining it, due to `opts_extend`
	-- 		sources = {
	-- 			default = { 'lsp', 'path', 'snippets', 'buffer' },
	-- 		},
	--
	-- 		-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
	-- 		-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
	-- 		-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
	-- 		--
	-- 		-- See the fuzzy documentation for more information
	-- 		fuzzy = { implementation = "prefer_rust_with_warning" }
	-- 	},
	-- 	opts_extend = { "sources.default" }
	-- },
	{
		-- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Additional lua configuration, makes nvim stuff amazing!
			"folke/neodev.nvim",
		},
		config = function()
			return {
				on_attach = function(_)
					vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })

					-- Rust
					vim.keymap.set("n", "<leader>re", "<Cmd>ExpandMacro<CR>", { desc = "Expand macro" })

					-- Create a command `:Format` local to the LSP buffer
					vim.api.nvim_buf_create_user_command(
						0,
						"Format",
						vim.lsp.buf.format,
						{ desc = "Format current buffer with LSP" }
					)
				end,
			}
		end,
	},
	{
		"chrisgrieser/nvim-lsp-endhints",
		event = "LspAttach",
		opts = {}, -- required, even if empty
		config = function()
			require("lsp-endhints").setup()
		end,
	},
	{
		"github/copilot.vim",
		config = function()
			-- Enable Copilot globally
			vim.g.copilot_enabled = true

			-- Disable default tab mapping
			vim.g.copilot_no_tab_map = true

			-- Set Alt+L as the accept mapping
			vim.keymap.set("i", "<A-l>", 'copilot#Accept("\\<CR>")', {
				expr = true,
				replace_keycodes = false,
			})
		end,
	},
	{
		"folke/sidekick.nvim",
		opts = {
			-- add any options here
			cli = {
				mux = {
					backend = "tmux",
					enabled = true,
				},
			},
		},
		keys = {
			{
				"<tab>",
				function()
					-- if there is a next edit, jump to it, otherwise apply it if any
					if not require("sidekick").nes_jump_or_apply() then
						return "<Tab>" -- fallback to normal tab
					end
				end,
				expr = true,
				desc = "Goto/Apply Next Edit Suggestion",
			},
			{
				"<c-.>",
				function()
					require("sidekick.cli").toggle()
				end,
				desc = "Sidekick Toggle",
				mode = { "n", "t", "i", "x" },
			},
			{
				"<leader>aa",
				function()
					require("sidekick.cli").toggle()
				end,
				desc = "Sidekick Toggle CLI",
			},
			{
				"<leader>as",
				function()
					require("sidekick.cli").select()
				end,
				-- Or to select only installed tools:
				-- require("sidekick.cli").select({ filter = { installed = true } })
				desc = "Select CLI",
			},
			{
				"<leader>ad",
				function()
					require("sidekick.cli").close()
				end,
				desc = "Detach a CLI Session",
			},
			{
				"<leader>at",
				function()
					require("sidekick.cli").send({ msg = "{this}" })
				end,
				mode = { "x", "n" },
				desc = "Send This",
			},
			{
				"<leader>af",
				function()
					require("sidekick.cli").send({ msg = "{file}" })
				end,
				desc = "Send File",
			},
			{
				"<leader>av",
				function()
					require("sidekick.cli").send({ msg = "{selection}" })
				end,
				mode = { "x" },
				desc = "Send Visual Selection",
			},
			{
				"<leader>ap",
				function()
					require("sidekick.cli").prompt()
				end,
				mode = { "n", "x" },
				desc = "Sidekick Select Prompt",
			},
			-- Example of a keybinding to open Claude directly
			{
				"<leader>ac",
				function()
					require("sidekick.cli").toggle({ name = "claude", focus = true })
				end,
				desc = "Sidekick Toggle Claude",
			},
		},
	},
}
