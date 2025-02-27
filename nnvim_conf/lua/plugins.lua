-- [[ Install `lazy.nvim` plugin manager ]]
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure plugins ]]
-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require("lazy").setup({
	-- NOTE: First, some plugins that don't require any configuration

	-- Detect tabstop and shiftwidth automatically
	"tpope/vim-sleuth",

	{
		"williamboman/mason.nvim",
		dependencies = { "williamboman/mason-lspconfig.nvim" },
		opts = {
			ensure_installed = {
				"typescript-language-server",
				"tailwindcss-language-server",
				"eslint-lsp",
				"prettierd",
			},
		},
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup()
			-- Never format with tsserver
			vim.lsp.buf.format({
				filter = function(client)
					print(client.name)
					return client.name ~= "tsserver" or client.name ~= "ts_ls"
				end,
			})
		end,
	},

	-- NOTE: This is where your plugins related to LSP can be installed.
	--  The configuration is done below. Search for lspconfig to find it below.
	{
		-- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			-- 'saghen/blink.cmp',

			-- Useful status updates for LSP
			-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
			-- { 'j-hui/fidget.nvim', opts = {} },

			-- Additional lua configuration, makes nvim stuff amazing!
			"folke/neodev.nvim",
		},
		config = function()
			require("configs.lspconfig")
		end,
	},
	-- Useful plugin to show you pending keybinds.
	-- { 'folke/which-key.nvim', opts = {} },
	-- {
	--     -- Adds git related signs to the gutter, as well as utilities for managing changes
	--     "lewis6991/gitsigns.nvim",
	--     opts = {
	--         -- See `:help gitsigns.txt`
	--         -- signs = {
	--         --     add = { text = '+' },
	--         --     change = { text = '~' },
	--         --     delete = { text = '_' },
	--         --     topdelete = { text = '‾' },
	--         --     changedelete = { text = '~' },
	--         -- },
	--         sign_priority = 100,
	--         on_attach = function(bufnr)
	--             -- don't override the built-in and fugitive keymaps
	--             local gs = package.loaded.gitsigns
	--             vim.keymap.set({ "n", "v" }, "]c", function()
	--                 if vim.wo.diff then
	--                     return "]c"
	--                 end
	--                 vim.schedule(function()
	--                     gs.next_hunk()
	--                 end)
	--                 return "<Ignore>"
	--             end, { expr = true, buffer = bufnr, desc = "Jump to next hunk" })
	--             vim.keymap.set({ "n", "v" }, "[c", function()
	--                 if vim.wo.diff then
	--                     return "[c"
	--                 end
	--                 vim.schedule(function()
	--                     gs.prev_hunk()
	--                 end)
	--                 return "<Ignore>"
	--             end, { expr = true, buffer = bufnr, desc = "Jump to previous hunk" })
	--
	--             vim.keymap.set({ "n", "v" }, "<leader>gs", ":Gitsigns stage_hunk<CR>", { desc = "[G]it [S]tage hunk" })
	--             vim.keymap.set({ "n", "v" }, "<leader>gu", ":Gitsigns reset_hunk<CR>", { desc = "[G]it [U]ndo hunk" })
	--             vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { desc = "[G]it [p]op hunk diff" })
	--             vim.keymap.set("n", "]g", ": Gitsigns next_hunk<CR>", { desc = "next git hunk" })
	--             vim.keymap.set("n", "[g", ": Gitsigns prev_hunk<CR>", { desc = "prev git hunk" })
	--         end,
	--     },
	-- },
	-- Fuzzy Finder (files, lsp, etc)
	-- {
	--     'nvim-tree/nvim-tree.lua',
	--     -- lazy = false,
	--     event = "VeryLazy",
	--     config = function()
	--         require("nvim-tree").setup({
	--             view = {
	--                 width = 50,
	--             },
	--         })
	--
	--         vim.keymap.set("n", "<C-q>", ":NvimTreeFindFileToggle<CR>", { desc = "Toggle nvim tree" })
	--     end
	-- },
	{
		"chrisgrieser/nvim-lsp-endhints",
		event = "LspAttach",
		opts = {}, -- required, even if empty
		config = function()
			require("lsp-endhints").setup()
		end,
	},
	{
		-- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				-- Add languages to be installed here that you want installed for treesitter
				ensure_installed = {
					"c",
					"cpp",
					"go",
					"lua",
					"python",
					"rust",
					"tsx",
					"javascript",
					"typescript",
					"vimdoc",
					"vim",
					"bash",
				},

				-- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
				auto_install = false,

				highlight = { enable = true },
				indent = { enable = true },
				incremental_selection = {
					enable = false,
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							["aa"] = "@parameter.outer",
							["ia"] = "@parameter.inner",
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
							["al"] = "@statement.outer",
							["il"] = "@statement.outer",
						},
					},
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = {
							["]m"] = "@function.outer",
							["]]"] = "@class.outer",
							["]l"] = "@statement.outer",
						},
						goto_next_end = {
							["]M"] = "@function.outer",
							["]["] = "@class.outer",
						},
						goto_previous_start = {
							["[m"] = "@function.outer",
							["[l"] = "@statement.outer",
							["[["] = "@class.outer",
						},
						goto_previous_end = {
							["[M"] = "@function.outer",
							["[]"] = "@class.outer",
						},
					},
					swap = {
						enable = true,
						swap_next = {
							["<leader>a"] = "@parameter.inner",
						},
						swap_previous = {
							["<leader>A"] = "@parameter.inner",
						},
					},
				},
			})
		end,
	},

	-- sharon configs
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			local build_common_surround = function(object_name, opener, closer)
				return {
					add = function()
						return { { object_name .. opener }, { closer } }
					end,
					find = function()
						local config = require("nvim-surround.config")
						return config.get_selection({ node = "generic_type" })
					end,
					delete = "^(" .. object_name .. opener .. ")().-(" .. closer .. ")()$",
					change = {
						target = "^(" .. object_name .. opener .. ")().-(" .. closer .. ")()$",
						-- replacement = function()
						--     local config = require("nvim-surround.config")
						--     local result = config.get_input("Enter the new type: ")
						--     if result then
						--         return { { result .. opener }, { closer } }
						--     end
						-- end,
					},
				}
			end
			require("nvim-surround").setup({
				surrounds = {
					["R"] = build_common_surround("anyhow::Result", "<", ">"),
					["V"] = build_common_surround("Vec", "<", ">"),
					["O"] = build_common_surround("Option", "<", ">"),
					["S"] = build_common_surround("Some", "(", ")"),
					["D"] = build_common_surround("dbg!", "(", ")"),
					-- ["S"] = {
					--     add = function()
					--         return { { "Some(" }, { ")" } }
					--     end,
					-- },
					["K"] = {
						add = function()
							return { { "Ok(" }, { ")" } }
						end,
					},
					-- "generic"
					["g"] = {
						add = function()
							local config = require("nvim-surround.config")
							local result = config.get_input("Enter the generic name: ")
							if result then
								return { { result .. "<" }, { ">" } }
							end
						end,
						find = function()
							local config = require("nvim-surround.config")
							return config.get_selection({ node = "generic_type" })
						end,
						delete = "^(.-<)().-(>)()$",
						change = {
							target = "^(.-<)().-(>)()$",
							replacement = function()
								local config = require("nvim-surround.config")
								local result = config.get_input("Enter the generic name: ")
								if result then
									return { { result .. "<" }, { ">" } }
								end
							end,
						},
					},
				},
			})
		end,
	},
	{
		"tpope/vim-fugitive",
		lazy = false,
		config = function()
			vim.keymap.set("n", "<leader>gB", "<cmd> Git blame<CR>", { desc = "Run [G]it [B]lame on file" })
			vim.keymap.set("n", "<leader>gf", ":Git<CR>/taged<CR>:noh<CR>j", { desc = "[G]it [F]ugitive" })
			vim.keymap.set("n", "<leader>gl", ":Git log<CR>", { desc = "[G]it [L]og" })
			vim.keymap.set("n", "<leader>ga", ":Git commit --amend<CR>", { desc = "[G]it [A]mend" })
			vim.keymap.set("n", "<leader>gc", ':Git commit -m "', { desc = "[G]it [C]ommit" })
			vim.keymap.set("n", "<leader>grm", ":Git pull origin main --rebase<CR>", { desc = "[G]it [R]ebase [M]ain" })
			vim.keymap.set("n", "<leader>grc", ":Git rebase --continue<CR>", { desc = "[G]it [R]ebase [C]ontinue" })
			vim.keymap.set("n", "<leader>gra", ":Git rebase --abort<CR>", { desc = "[G]it [R]ebase [A]bort" })
		end,
	},
	-- {
	--     "folke/persistence.nvim",
	--     event = "BufReadPre",
	--     opts = {},
	--     -- stylua: ignore
	--     keys = {
	--         { "<leader>qs", function() require("persistence").load() end,                desc = "Restore Session" },
	--         { "<leader>qS", function() require("persistence").select() end,              desc = "Select Session" },
	--         { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
	--         { "<leader>qd", function() require("persistence").stop() end,                desc = "Don't Save Current Session" },
	--     },
	-- },
	{
		"rmagatti/auto-session",
		lazy = false,
		config = function()
			require("auto-session").setup({
				log_level = "error",
				auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
			})
		end,
	},
	{
		"mrjones2014/smart-splits.nvim",
		config = function()
			require("smart-splits").setup()
			-- Tmux window navigation
			vim.keymap.set("n", "<A-h>", require("smart-splits").resize_left)
			vim.keymap.set("n", "<A-j>", require("smart-splits").resize_down)
			vim.keymap.set("n", "<A-k>", require("smart-splits").resize_up)
			vim.keymap.set("n", "<A-l>", require("smart-splits").resize_right)
			-- moving between splits
			vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left)
			vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down)
			vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up)
			vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right)
			vim.keymap.set("t", "<C-h>", require("smart-splits").move_cursor_left)
			vim.keymap.set("t", "<C-j>", require("smart-splits").move_cursor_down)
			vim.keymap.set("t", "<C-k>", require("smart-splits").move_cursor_up)
			vim.keymap.set("t", "<C-l>", require("smart-splits").move_cursor_right)
			-- swapping buffers between windows
			vim.keymap.set("n", "<leader><leader>h", require("smart-splits").swap_buf_left)
			vim.keymap.set("n", "<leader><leader>j", require("smart-splits").swap_buf_down)
			vim.keymap.set("n", "<leader><leader>k", require("smart-splits").swap_buf_up)
			vim.keymap.set("n", "<leader><leader>l", require("smart-splits").swap_buf_right)
		end,
	},
	{
		"ThePrimeagen/harpoon",
		branch = "master",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			-- Harpoon 2
			-- local harpoon = require("harpoon")
			-- vim.keymap.set("n", "<leader>ha", function() harpoon:list():append() end)
			-- vim.keymap.set("n", "<leader>hm", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
			--
			-- vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end)
			-- vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end)
			-- vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end)
			-- vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end)

			vim.keymap.set("n", "<leader>ha", function()
				require("harpoon.mark").add_file()
			end)
			vim.keymap.set("n", "<leader>hm", function()
				require("harpoon.ui").toggle_quick_menu()
			end)

			vim.keymap.set("n", "<leader>1", function()
				require("harpoon.ui").nav_file(1)
			end)
			vim.keymap.set("n", "<leader>2", function()
				require("harpoon.ui").nav_file(2)
			end)
			vim.keymap.set("n", "<leader>3", function()
				require("harpoon.ui").nav_file(3)
			end)
			vim.keymap.set("n", "<leader>4", function()
				require("harpoon.ui").nav_file(4)
			end)
			vim.keymap.set("n", "<leader>5", function()
				require("harpoon.ui").nav_file(5)
			end)
			vim.keymap.set("n", "<leader>6", function()
				require("harpoon.ui").nav_file(6)
			end)
		end,
	},
	{
		dir = "/Users/sharonavni/personal/git-mediate.nvim",
		dependencies = { "skywind3000/asyncrun.vim" },
		event = "VeryLazy",
		config = function()
			require("git-mediate").setup()
			vim.keymap.set("n", "<leader>g[", ":GitMediate<CR>", { desc = "Run git mediate conflict resolver" })
		end,
		lazy = false,
	},
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				panel = {
					enabled = true,
					auto_refresh = true,
				},
				suggestion = {
					enabled = true,
					auto_trigger = true,
					accept = false, -- disable built-in keymapping
				},
			})
		end,
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {},
		-- stylua: ignore
		keys = {
			{ "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
			{ "S",     mode = { "n", "o" },      function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
			{ "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
			{ "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
			{ "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
		},
	},
	-- {
	-- 	"ggandor/leap.nvim",
	-- 	lazy = false,
	-- 	config = function()
	-- 		require("leap").add_default_mappings()
	-- 		-- require('leap').add_repeat_mappings(';', ',', {
	-- 		--     relative_directions = true,
	-- 		-- })
	-- 	end,
	-- },
	{
		"folke/trouble.nvim",
		lazy = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
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
		"windwp/nvim-autopairs",
		opts = {
			fast_wrap = {},
			disable_filetype = { "vim" },
		},
		config = function(_, opts)
			require("nvim-autopairs").setup(opts)
			--
			-- -- setup cmp for autopairs
			-- local cmp_autopairs = require "nvim-autopairs.completion.cmp"
			-- require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},
	{
		"lewis6991/spaceless.nvim",
		config = function()
			require("spaceless").setup()
		end,
		lazy = false,
	},
	-- {
	--     "olimorris/codecompanion.nvim",
	--     event = "VeryLazy",
	--     dependencies = {
	--         { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	--         { "nvim-lua/plenary.nvim" },
	--         -- Test with blink.cmp
	--         -- {
	--         --     "saghen/blink.cmp",
	--         --     lazy = false,
	--         --     version = "*",
	--         --     opts = {
	--         --         keymap = {
	--         --             preset = "enter",
	--         --             ["<S-Tab>"] = { "select_prev", "fallback" },
	--         --             ["<Tab>"] = { "select_next", "fallback" },
	--         --         },
	--         --         sources = {
	--         --             default = { "lsp", "path", "buffer", "codecompanion" },
	--         --             cmdline = {}, -- Disable sources for command-line mode
	--         --         },
	--         --     },
	--         -- },
	--         -- Test with nvim-cmp
	--         -- { "hrsh7th/nvim-cmp" },
	--     },
	--     config = function()
	--         require("codecompanion").setup({
	--             --Refer to: https://github.com/olimorris/codecompanion.nvim/blob/main/lua/codecompanion/config.lua
	--             strategies = {
	--                 --NOTE: Change the adapter as required
	--                 chat = {
	--                     adapter = "copilot",
	--                     keymaps = {
	--                         send = {
	--                             modes = { n = "<M-l>", i = "<M-l>" },
	--                         },
	--                         close = {
	--                             modes = { n = "<M-~>", i = "<M-~>" },
	--                         },
	--                         -- Add further custom keymaps here
	--                     },
	--                 },
	--                 inline = { adapter = "copilot" },
	--             },
	--             opts = {
	--                 log_level = "DEBUG",
	--             },
	--         })
	--         vim.keymap.set("n", "<leader>aa", "<cmd>CodeCompanionChat<CR>", { desc = "AI Code Companion" })
	--         vim.keymap.set("v", "<leader>aa", ":CodeCompanion ",
	--             { desc = "Run code companion on highlighted code" })
	--     end
	-- },
	-- {
	--     "yetone/avante.nvim",
	--     {
	--         "yetone/avante.nvim",
	--         event = "VeryLazy",
	--         lazy = false,
	--         version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
	--         opts = {
	--             -- add any opts here
	--             -- for example
	--             provider = "copilot",
	--             -- claude = {
	--             --     endpoint = "https://api.anthropic.com",
	--             --     model = "claude-3-5-sonnet-20241022",
	--             --     temperature = 0,
	--             --     max_tokens = 4096,
	--             -- },
	--         },
	--         -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
	--         build = "make BUILD_FROM_SOURCE=true",
	--         dependencies = {
	--             "stevearc/dressing.nvim",
	--             "nvim-lua/plenary.nvim",
	--             "MunifTanjim/nui.nvim",
	--             "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
	--         }
	--     }
	-- },
	{
		"gbprod/substitute.nvim",
		config = function()
			require("substitute").setup({
				range = {
					prefix = "g",
				},
			})
			-- Exchange
			vim.keymap.set("n", "gx", "<cmd>lua require('substitute.exchange').operator()<cr>", { desc = "" })
			vim.keymap.set("v", "gx", "<cmd>lua require('substitute.exchange').visual()<cr>", { desc = "" })
			vim.keymap.set("n", "gp", "<cmd>lua require('substitute').operator()<cr>", { desc = "" })
			vim.keymap.set("n", "gP", "<cmd>lua require('substitute').eol()<cr>", { desc = "" })
		end,
	},
	{
		"tpope/vim-rsi",
		lazy = false,
	},
	{
		"stevearc/oil.nvim",
		event = "VeryLazy",
		config = function()
			require("oil").setup()
			vim.keymap.set("n", "|", "<CMD>Oil<CR>", { desc = "Open parent directory" })
		end,
	},
	{

		"echasnovski/mini.diff",
		event = "VeryLazy",
		keys = {
			{
				"<leader>gp",
				function()
					require("mini.diff").toggle_overlay(0)
				end,
				desc = "Toggle mini.diff overlay",
			},
		},
		opts = {
			view = {
				style = "sign",
				signs = {
					add = "▎",
					change = "▎",
					delete = "",
				},
			},
		},
	},
	{
		"navarasu/onedark.nvim",
		lazy = false,
		config = function()
			require("onedark").setup({
				-- Main options --
				style = "deep",   -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
				transparent = false, -- Show/hide background
				term_colors = true, -- Change terminal color as per the selected theme style
				ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden
				cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

				-- toggle theme style ---
				toggle_style_key = "<leader>tx",
			})
			vim.cmd("colorscheme onedark")
		end,
	},
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = require("configs.snacks"),
		keys = {
			-- vim.keymap.set("n", "<C-q>", ":NvimTreeFindFileToggle<CR>", { desc = "Toggle nvim tree" })
			{
				"<leader>e",
				function()
					Snacks.explorer.open()
				end,
				desc = "Lazygit",
			},
			-- { "<leader>gg", function() Snacks.lazygit() end,                                        desc = "Lazygit" },
			-- { "<leader>gl", function() Snacks.lazygit.log() end,                                    desc = "Lazygit Log (cwd)" },
			{
				"<C-,>",
				function()
					Snacks.terminal.toggle()
				end,
				desc = "Toggle Terminal",
			},
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
			{
				"<leader>op",
				function()
					Snacks.picker.projects()
				end,
				desc = "Open Projects",
			},
			{
				"<leader>b",
				function()
					Snacks.picker.buffers()
				end,
				desc = "Buffers",
			},
			-- find
			{
				"<leader>sc",
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
				desc = "Command History",
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
				"<leader>sd",
				function()
					Snacks.picker.diagnostics()
				end,
				desc = "Diagnostics",
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
				"gr",
				function()
					Snacks.picker.lsp_references()
				end,
				nowait = true,
				desc = "References",
			},
			{
				"gI",
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
				desc = "LSP Symbols",
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
	{
		"mg979/vim-visual-multi",
		event = "VeryLazy",
		branch = "master",
		config = function()
			vim.cmd([[
                VMTheme codedark
            ]])
		end,
	},
	{
		"nvim-neorg/neorg",
		lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
		version = "*", -- Pin Neorg to the latest stable release
		-- config = {
		--     vim.keymap.set("n", "<leader>n", ":Neorg<CR>", { desc = "Open Neorg" })
		-- }
		-- config = true,
		build = ":Neorg sync-parsers",
		config = function()
			require("neorg").setup({
				load = {
					["core.defaults"] = {},
					["core.concealer"] = {},
					["core.syntax"] = {},
					["core.summary"] = {},
					["core.dirman"] = {
						config = {
							workspaces = {
								notes = "~/notes",
							},
							default_workspace = "notes",
						},
					},
				},
			})

			vim.wo.foldlevel = 99
			vim.wo.conceallevel = 2

			vim.keymap.set("n", "<leader>njt", ":Neorg journal today<CR>", { desc = "Neorg Journal Today" })
			vim.keymap.set("n", "<leader>njy", ":Neorg journal yesterday<CR>", { desc = "Neorg Journal Yesterday" })
			vim.keymap.set("n", "<leader><CR>", "<Plug>(neorg.esupports.hop.hop-link)", { desc = "Follow link" })
		end,
	},
	{
		"kevinhwang91/nvim-bqf",
		lazy = false,
	},
	{
		"johmsalas/text-case.nvim",
		event = "VeryLazy",
		-- lazy = false,
		config = function()
			require("textcase").setup({})
		end,
	},

	-- {
	--     "ggandor/flit.nvim",
	--     lazy = false,
	--     config = function()
	--         require('flit').setup {
	--             keys = { f = 'f', F = 'F', t = 't', T = 'T' },
	--             -- A string like "nv", "nvo", "o", etc.
	--             labeled_modes = "v",
	--             -- Repeat with the trigger key itself.
	--             clever_repeat = true,
	--             multiline = true,
	--             -- Like `leap`s similar argument (call-specific overrides).
	--             -- E.g.: opts = { equivalence_classes = {} }
	--             opts = {}
	--         }
	--     end
	-- },
	-- {
	--     -- Set lualine as statusline
	--     'nvim-lualine/lualine.nvim',
	--     -- See `:help lualine.txt`
	--     config = function()
	--         require('lualine').setup({
	--             sections = {
	--                 lualine_c = { { 'filename', path = 1 } }
	--             },
	--         })
	--     end,
	-- },
	-- {
	--     'rcarriga/nvim-dap-ui',
	--     lazy = false,
	--     dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
	--     config = function()
	--         require('dapui').setup()
	--         local dap, dapui = require("dap"), require("dapui")
	--         dap.listeners.before.attach.dapui_config = function()
	--             dapui.open()
	--         end
	--         dap.listeners.before.launch.dapui_config = function()
	--             dapui.open()
	--         end
	--         dap.listeners.before.event_terminated.dapui_config = function()
	--             dapui.close()
	--         end
	--         dap.listeners.before.event_exited.dapui_config = function()
	--             dapui.close()
	--         end
	--
	--         vim.keymap.set("n", "<leader>dt", "<cmd>DapToggleBreakpoint<CR>", { desc = "[D]ebug [T]oggle Breakpoint" })
	--         vim.keymap.set("n", "<leader>do", "<cmd>DapStepOver<CR>", { desc = "[D]ebug [O]ver" })
	--         vim.keymap.set("n", "<leader>di", "<cmd>DapStepInto<CR>", { desc = "[D]ebug [I]nto" })
	--         vim.keymap.set("n", "<leader>dc", "<cmd>DapContinue<CR>", { desc = "[D]ebug [C]ontinue" })
	--         vim.keymap.set("n", "<leader>dx", "<cmd>DapTerminate<CR>", { desc = "[D]ebug [X]it" })
	--         vim.keymap.set("n", "<leader>dx", "<cmd>DapTerminate<CR>", { desc = "[D]ebug [X]it" })
	--     end
	-- },
	-- {
	--     'unblevable/quick-scope',
	--     config = function()
	--         vim.cmd [[
	--           highlight QuickScopePrimary guifg='#af0f5f' gui=underline ctermfg=155 cterm=underline
	--           highlight QuickScopeSecondary guifg='#5000ff' gui=underline ctermfg=81 cterm=underline
	--           ]]
	--     end,
	-- },
	-- {
	--     "ggandor/leap-spooky.nvim",
	--     lazy = false,
	--     config = function()
	--         require('leap-spooky').setup {
	--         }
	--     end
	-- },
	-- Rustacenvim config from appelgriebsch/Nv
	-- {
	--     "mrcjkb/rustaceanvim",
	--     ft = { "rust" },
	--     config = function()
	--         local codelldb = require('mason-registry').get_package('codelldb')
	--         local extension_path = codelldb:get_install_path() .. '/extension/'
	--         local codelldb_path = extension_path .. 'adapter/codelldb'
	--         local liblldb_path = extension_path .. 'lldb/lib/liblldb.dylib'
	--
	--         local cfg = require('rustaceanvim.config')
	--         vim.g.rustaceanvim = {
	--             server = {
	--                 on_attach = function(_, _)
	--                     vim.lsp.inlay_hint.enable()
	--                 end,
	--                 default_settings = {
	--                     -- rust-analyzer language server configuration
	--                     ['rust-analyzer'] = {
	--                         checkOnSave = {
	--                             enable = true,
	--                             command = "check",
	--                             -- Disable running tests automatically
	--                             allTargets = false,
	--
	--                             -- extraArgs = { "--no-deps" },
	--                         },
	--                         check = {
	--                             workspace = false
	--                         },
	--                         -- Disable automatic running of tests
	--                         cargo = {
	--                             autoreload = false,
	--                             runBuildScripts = false,
	--                         },
	--                     },
	--                 },
	--             },
	--             dap = {
	--                 adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
	--             },
	--         }
	--         vim.keymap.set("n", "<leader>re", "<cmd>RustLsp expandMacro<CR>", { desc = "[R]ust expand macro" })
	--         vim.keymap.set("n", "<leader>rc", "<cmd>RustLsp openCargo<CR>", { desc = "[R]ust open cargo" })
	--         vim.keymap.set("n", "<leader>rp", "<cmd>RustLsp parentModule<CR>", { desc = "[R]ust open parent module" })
	--         vim.keymap.set("n", "<leader>rr", "<cmd>RustLsp reloadWorkspace<CR>", { desc = "[R]ust [R]estart" })
	--         vim.keymap.set("n", "<leader>rd", "<cmd>RustLsp renderDiagnostic <CR>", { desc = "[R]ust [D]iagnostics" })
	--     end
	-- },
	-- {
	--     'ibhagwan/fzf-lua',
	--     lazy = false,
	--     config = function()
	--         -- require 'fzf-lua'.setup {
	--         --     winopts = {
	--         --         split = "belowright new",
	--         --         height = 0.4
	--         --     }
	--         -- }
	--     end
	--
	-- },

	{
		"stevearc/conform.nvim",
		opts = {},
		config = function()
			require("conform").setup({
				-- event = { "BufReadPre", "BufNewFile" },
				log_level = vim.log.levels.DEBUG,
				-- format_after_save = {},
				-- vim.api.nvim_create_autocmd("BufWritePre", {
				--     pattern = "*",
				--     callback = function(args)
				--         require("conform").format({ bufnr = args.buf })
				--         -- Wait for the format to complete and reload the buffer
				--     end,
				-- }),
				-- formatters = {
				--     -- Override the default rustfmt config
				--     rustfmt = {
				--         command = "cargo",
				--         args = {
				--             "+nightly-2024-07-01",
				--             "fmt",
				--             "--",
				--         },
				--     },
				-- },
				formatters_by_ft = {
					lua = { "stylua" },
					rust = { "rustfmt" },
					typescript = { "prettierd", "prettier", stop_after_first = true },
					typescriptreact = { "prettierd", "prettier", stop_after_first = true },
					javascript = { "prettierd", "prettier", stop_after_first = true },
					javascriptreact = { "prettierd", "prettier", stop_after_first = true },

					-- ["*"] = { "codespell", "trim_whitespace" },
					-- Use the "_" filetype to run formatters on filetypes that don't
					-- have other formatters configured.
					-- ["_"] = { "trim_whitespace" },
				},
			})
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*",
				callback = function(args)
					require("conform").format({ bufnr = args.buf })
				end,
			})

			-- vim.api.nvim_create_autocmd('FileType', {
			--     pattern = vim.tbl_keys(require('conform').formatters_by_ft),
			--     group = vim.api.nvim_create_augroup('conform_formatexpr', { clear = true }),
			--     callback = function() vim.opt_local.formatexpr = 'v:lua.require("conform").formatexpr()' end,
			-- })
			-- vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
			-- vim.g.auto_conform_on_save = true
			-- vim.api.nvim_create_autocmd('BufWritePre', {
			--     pattern = '*',
			--     callback = function(args)
			--         if vim.g.auto_conform_on_save then require('conform').format({ bufnr = args.buf, timeout_ms = nil }) end
			--     end,
			-- })
			-- vim.api.nvim_create_user_command('ConformToggleOnSave', function()
			--     vim.g.auto_conform_on_save = not vim.g.auto_conform_on_save
			--     vim.notify('Auto-Conform on save: ' .. (vim.g.auto_conform_on_save and 'Enabled' or 'Disabled'))
			-- end, {})
		end,
	},
	{
		-- Autocompletion
		"hrsh7th/nvim-cmp",
		dependencies = {
			-- Snippet Engine & its associated nvim-cmp source
			-- Adds LSP completion capabilities
			"hrsh7th/cmp-nvim-lsp",

			-- Adds a number of user-friendly snippets
			"onsails/lspkind.nvim",
		},
		config = require("configs.cmp_config"),
	},
})
