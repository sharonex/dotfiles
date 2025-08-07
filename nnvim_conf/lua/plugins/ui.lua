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
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
		  require('onedark').setup {
		    style = 'dark'
		  }
		  -- Enable theme
		  require('onedark').load()
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		lazy = false,
		config = function()
			require("configs.lualine")
		end,
	},
	{
		"b0o/incline.nvim",
		event = "UiEnter",
		dependencies = "echasnovski/mini.icons",
		config = function()
			require("configs.incline")
		end,
	},
	{
		"Bekaboo/dropbar.nvim",
		event = "UiEnter",
		config = function()
			require("configs.dropbar")
		end,
	},
	{
		"j-hui/fidget.nvim",
		opts = {
			-- options
		},
	},
}
