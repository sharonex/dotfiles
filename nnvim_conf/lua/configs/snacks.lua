return {
	-- your configuration comes here
	-- or leave it empty to use the default settings
	-- refer to the configuration section below
	bigfile = { enabled = true },
	-- notifier = { enabled = true },
	quickfile = { enabled = true },
	lazygit = { enabled = false },
	explorer = { enabled = false },
	toggle = { enabled = true },
	terminal = {
		enabled = true,
		keys = {
			q = "hide",
			gf = function(self)
				local f = vim.fn.findfile(vim.fn.expand("<cfile>"), "**")
				if f == "" then
					Snacks.notify.warn("No file under cursor")
				else
					self:hide()
					vim.schedule(function()
						vim.cmd("e " .. f)
					end)
				end
			end,
			term_normal = {
				"<esc>",
				function(self)
					self.esc_timer = self.esc_timer or (vim.uv or vim.loop).new_timer()
					if self.esc_timer:is_active() then
						self.esc_timer:stop()
						vim.cmd("stopinsert")
					else
						self.esc_timer:start(200, 0, function() end)
						return "<esc>"
					end
				end,
				mode = "t",
				expr = true,
				desc = "Double escape to normal mode",
			},
		},
	},
	gitbrowse = { enabled = true },
	picker = {
		enabled = true,
		layout = {
			preset = "ivy",
		},
		win = {
			input = {
				keys = {
					["<Tab>"] = { "list_next", mode = { "i" } },
					["<S-Tab>"] = { "list_prev", mode = { "i" } },
				},
			},
		},
		sources = {
			git_files = {
				preview = nil,
			},
			files = {
				preview = nil,
			},
		},
	},
}
