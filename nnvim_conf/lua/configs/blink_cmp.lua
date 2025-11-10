local default_sources = { "lsp", "path", "calc", "snippets", "buffer", "lazydev" }

require("blink.cmp").setup({
	keymap = {
		preset = "default",
		["<CR>"] = { "accept", "fallback" },
		["<Tab>"] = {
			function(cmp)
				-- First check if there's a Copilot suggestion
				if vim.fn["copilot#GetDisplayedSuggestion"]().text ~= "" then
					return vim.fn["copilot#Accept"]("")
				end

				-- Then handle blink.cmp menu
				if cmp.is_menu_visible() then
					return cmp.select_next()
				elseif cmp.snippet_active() then
					return cmp.snippet_forward()
				end

				-- Check for Sidekick next edit suggestion
				local sidekick_ok, sidekick = pcall(require, "sidekick")
				if sidekick_ok and sidekick.nes_jump_or_apply then
					if sidekick.nes_jump_or_apply() then
						return
					end
				end

				-- Fallback to regular tab
				return vim.api.nvim_replace_termcodes("<Tab>", true, true, true)
			end,
			"fallback",
		},
		["<S-Tab>"] = {
			function(cmp)
				if cmp.is_menu_visible() then
					return cmp.select_prev()
				elseif cmp.snippet_active() then
					return cmp.snippet_backward()
				end
			end,
			"fallback",
		},
	},
	enabled = function()
		return true
	end,
	signature = {
		enabled = true,
		window = {
			border = "rounded",
			scrollbar = false,
		},
	},
	sources = {
		default = default_sources,
		providers = {
			calc = {
				name = "calc",
				module = "blink.compat.source",
			},
			lazydev = {
				name = "LazyDev",
				module = "lazydev.integrations.blink",
				fallbacks = { "lsp" },
			},
		},
	},
	appearance = {
		kind_icons = {
			Snippet = "",
		},
	},
	cmdline = {
		completion = {
			menu = {
				auto_show = true,
			},
			ghost_text = {
				enabled = false,
			},
			list = {
				selection = {
					preselect = true,
					auto_insert = false,
				},
			},
		},
	},
	completion = {
		keyword = {
			range = "prefix",
		},
		trigger = {
			show_on_trigger_character = true,
			show_on_keyword = true,
			show_on_blocked_trigger_characters = {},
		},
		list = {
			selection = {
				preselect = true,
				auto_insert = false,
			},
		},
		accept = {
			auto_brackets = {
				enabled = true,
				override_brackets_for_filetypes = {
					tex = { "{", "}" },
				},
			},
		},
		menu = {
			min_width = 20,
			border = "rounded",
			winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
			draw = {
				columns = { { "kind_icon" }, { "label", gap = 1 }, { "source" } },
				components = {
					label = {
						text = require("colorful-menu").blink_components_text,
						highlight = require("colorful-menu").blink_components_highlight,
					},
					source = {
						text = function(ctx)
							local map = {
								["lsp"] = "[]",
								["path"] = "[󰉋]",
								["snippets"] = "[]",
							}

							return map[ctx.item.source_id]
						end,
						highlight = "BlinkCmpDoc",
					},
				},
			},
		},
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 100,
			update_delay_ms = 50,
			window = {
				max_width = math.min(80, vim.o.columns),
				border = "rounded",
			},
		},
	},
})
