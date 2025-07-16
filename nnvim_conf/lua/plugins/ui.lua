-- UI and Appearance Plugins

return {
	{
		"folke/which-key.nvim",
		opts_extend = { "spec" },
		opts = {
			preset = "helix",
			defaults = {},
			spec = {
				{
					mode = { "n", "v" },
					-- Main leader groups
					{ "<leader>b", group = "buffer", icon = { icon = "󰈚 ", color = "blue" }, expand = function() return require("which-key.extras").expand.buf() end },
					{ "<leader>c", group = "code", icon = { icon = "󰨞 ", color = "yellow" } },
					{ "<leader>d", group = "debug", icon = { icon = "󰃤 ", color = "red" } },
					{ "<leader>dp", group = "profiler", icon = { icon = "󰄉 ", color = "orange" } },
					{ "<leader>f", group = "file/find", icon = { icon = "󰈞 ", color = "green" } },
					{ "<leader>g", group = "git", icon = { icon = "󰊢 ", color = "orange" } },
					{ "<leader>gh", group = "hunks", icon = { icon = "󰊢 ", color = "orange" } },
					{ "<leader>gr", group = "rebase", icon = { icon = "󰊢 ", color = "orange" } },
					{ "<leader>q", group = "quit/session", icon = { icon = "󰗼 ", color = "red" } },
					{ "<leader>r", group = "rename", icon = { icon = "󰑕 ", color = "cyan" } },
					{ "<leader>s", group = "search", icon = { icon = "󰍉 ", color = "purple" } },
					{ "<leader>t", group = "tabs", icon = { icon = "󰓩 ", color = "blue" } },
					{ "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
					{ "<leader>w", group = "windows", icon = { icon = "󰖲 ", color = "blue" }, proxy = "<c-w>", expand = function() return require("which-key.extras").expand.win() end },
					{ "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
					
					-- Double leader for special actions
					{ "<leader><leader>", group = "window swap", icon = { icon = "󰹼 ", color = "magenta" } },
					
					-- Tab management (legacy support)
					{ "<leader><tab>", group = "tabs", icon = { icon = "󰓩 ", color = "blue" } },
					
					-- Navigation groups
					{ "[", group = "prev", icon = { icon = "󰒮 ", color = "blue" } },
					{ "]", group = "next", icon = { icon = "󰒭 ", color = "blue" } },
					{ "g", group = "goto", icon = { icon = "󰍉 ", color = "purple" } },
					{ "gs", group = "surround", icon = { icon = "󰅪 ", color = "yellow" } },
					{ "z", group = "fold", icon = { icon = "󰘖 ", color = "cyan" } },
					
					-- Better descriptions for specific actions
					{ "gx", desc = "Open with system app" },
					{ "<leader>l", desc = "Open diagnostic float" },
					{ "<leader>g[", desc = "Git mediate" },
					{ "<leader>xl", desc = "Toggle diagnostic lines" },
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
			})
			vim.cmd("colorscheme onedark")
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		init = function()
			vim.g.lualine_laststatus = vim.o.laststatus
			if vim.fn.argc(-1) > 0 then
				-- set an empty statusline till lualine loads
				vim.o.statusline = " "
			else
				-- hide the statusline on the starter page
				vim.o.laststatus = 0
			end
		end,
		opts = function()
			local icons = {
				misc = {
					dots = "󰇘",
				},
				diagnostics = {
					Error = " ",
					Warn = " ",
					Hint = " ",
					Info = " ",
				},
				git = {
					added = " ",
					modified = " ",
					removed = " ",
				},
			}
			vim.o.laststatus = vim.g.lualine_laststatus

			local opts = {
				options = {
					theme = "auto",
					globalstatus = vim.o.laststatus == 3,
					disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
				},
				sections = {
					lualine_a = { "mode" },

					lualine_b = {
						{
							"filetype",
							icon_only = true,
							separator = "",
							padding = { left = 1, right = 0 },
						},
						{
							"filename",
							path = 1, -- 0: Just filename, 1: Relative path, 2: Absolute path
							shorting_target = 40, -- Shorten if file path exceeds this length
							symbols = {
								modified = "[+]",
								readonly = "[-]",
								unnamed = "[No Name]",
							},
						},
						{
							"diagnostics",
							symbols = {
								error = icons.diagnostics.Error,
								warn = icons.diagnostics.Warn,
								info = icons.diagnostics.Info,
								hint = icons.diagnostics.Hint,
							},
						},
					},
					lualine_c = { "branch" },
					lualine_x = { Snacks.profiler.status() },
					lualine_z = {
						function()
							return " " .. os.date("%R")
						end,
					},
				},
			}

			return opts
		end,
	},
	{
		"j-hui/fidget.nvim",
		opts = {
			-- options
		},
	},
}