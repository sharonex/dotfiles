-- Editor Enhancement Plugins

return {
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
					"kotlin",
					"java",
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
					-- swap = {
					-- 	enable = true,
					-- 	swap_next = {
					-- 		["<leader>a"] = "@parameter.inner",
					-- 	},
					-- 	swap_previous = {
					-- 		["<leader>A"] = "@parameter.inner",
					-- 	},
					-- },
				},
			})
		end,
	},
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
					find = object_name .. "%b" .. opener .. closer,
					delete = "^(" .. object_name:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1") .. opener:gsub(
						"([%^%$%(%)%%%.%[%]%*%+%-%?])",
						"%%%1"
					) .. ")().-(" .. closer:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1") .. ")()$",
					change = {
						target = "^(" .. object_name:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1") .. opener:gsub(
							"([%^%$%(%)%%%.%[%]%*%+%-%?])",
							"%%%1"
						) .. ")().-(" .. closer:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1") .. ")()$",
					},
				}
			end
			require("nvim-surround").setup({
				move_cursor = "sticky",
				surrounds = {
					["R"] = build_common_surround("anyhow::Result", "<", ">"),
					["V"] = build_common_surround("Vec", "<", ">"),
					["O"] = build_common_surround("Option", "<", ">"),
					["S"] = build_common_surround("Some", "(", ")"),
					["D"] = build_common_surround("dbg!", "(", ")"),
					["K"] = {
						add = function()
							return { { "Ok(" }, { ")" } }
						end,
					},
				},
			})
		end,
	},
	{
		"windwp/nvim-autopairs",
		opts = {
			fast_wrap = {},
			disable_filetype = { "vim" },
		},
		config = function(_, opts)
			require("nvim-autopairs").setup(opts)
		end,
	},
	{
		"lewis6991/spaceless.nvim",
		config = function()
			require("spaceless").setup()
		end,
		lazy = false,
	},
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
		"johmsalas/text-case.nvim",
		event = "VeryLazy",
		config = function()
			require("textcase").setup({})
		end,
	},
	{
		"folke/lazydev.nvim",
		ft = "lua",
		dependencies = {
			"Bilal2453/luvit-meta",
		},
		opts = {
			library = {
				"luvit-meta/library",
			},
		},
	},
}
