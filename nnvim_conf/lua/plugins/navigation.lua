-- Navigation and Movement Plugins

return {
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
		branch = "harpoon2",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		lazy = false,
		opts = {
			menu = {
				width = vim.api.nvim_win_get_width(0) - 4,
			},
			settings = {
				save_on_toggle = true,
				sync_on_ui_close = true,
			},
		},
		config = function(_) -- Add the opts parameter here
			local harpoon = require("harpoon")

			-- Set up highlight groups once (not on every call)
			local yellow = "#DCDCAA"
			local yellow_orange = "#D7BA7D"
			local background_color = "#282829"
			local grey = "#797C91"
			local light_blue = "#9CDCFE"

			vim.api.nvim_set_hl(0, "HarpoonInactive", { fg = grey, bg = background_color })
			vim.api.nvim_set_hl(0, "HarpoonActive", { fg = light_blue, bg = background_color })
			vim.api.nvim_set_hl(0, "HarpoonNumberActive", { fg = yellow, bg = background_color })
			vim.api.nvim_set_hl(0, "HarpoonNumberInactive", { fg = yellow_orange, bg = background_color })
			vim.api.nvim_set_hl(0, "TabLineFill", { fg = "white", bg = background_color })

			-- Cache for performance optimization
			local cache = {
				last_buf = nil,
				last_length = 0,
				last_result = "",
			}

			function Harpoon_files()
				local current_buf = vim.api.nvim_get_current_buf()
				local marks_length = harpoon:list():length()

				-- Use cache if buffer and harpoon list haven't changed
				if cache.last_buf == current_buf and cache.last_length == marks_length then
					return cache.last_result
				end

				local contents = {}
				local current_file_path = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":.")

				for index = 1, marks_length do
					local harpoon_file_path = harpoon:list():get(index).value
					local file_name = harpoon_file_path == "" and "(empty)"
						or vim.fn.fnamemodify(harpoon_file_path, ":t")

					if current_file_path == harpoon_file_path then
						contents[index] =
							string.format("%%#HarpoonNumberActive# %s. %%#HarpoonActive#%s ", index, file_name)
					else
						contents[index] =
							string.format("%%#HarpoonNumberInactive# %s. %%#HarpoonInactive#%s ", index, file_name)
					end
				end

				local result = table.concat(contents)

				-- Update cache
				cache.last_buf = current_buf
				cache.last_length = marks_length
				cache.last_result = result

				return result
			end

			vim.opt.showtabline = 2
			-- Use fewer events and debounce to improve performance
			vim.api.nvim_create_autocmd({ "BufEnter", "User" }, {
				pattern = { "*", "HarpoonUIWindowClosed", "HarpoonUIWindowOpened" },
				callback = function(ev)
					-- Only update tabline if we're in a normal buffer
					if vim.bo.buftype == "" then
						vim.o.tabline = Harpoon_files()
					end
				end,
			})
		end,
		keys = function()
			local keys = {
				{
					"<leader>h",
					function()
						require("harpoon"):list():add()
					end,
					desc = "Harpoon File",
				},
				{
					"<leader>H",
					function()
						local harpoon = require("harpoon")
						harpoon.ui:toggle_quick_menu(harpoon:list())
					end,
					desc = "Harpoon Quick Menu",
				},
			}

			for i = 1, 6 do
				table.insert(keys, {
					"<leader>" .. i,
					function()
						require("harpoon"):list():select(i)
					end,
					desc = "Harpoon to File " .. i,
				})
			end
			return keys
		end,
	},
	{
		"folke/flash.nvim",
		lazy = false,
		config = function()
			require("flash").setup(
				---@module 'flash'
				{
					jump = {
						autojump = true,
					},
					modes = {
						search = {
							enabled = false,
						},
						char = {
							enabled = false,
						},
					},
				}
			)
		end,
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},
			{
				"S",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
			{
				"r",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Remote Flash",
			},
		},
	},

	{
		"echasnovski/mini.files",
		version = false,
		keys = {
			{
				"<leader>e",
				function()
					local MiniFiles = require("mini.files")
					local current_file = vim.fn.expand("%:p")
					MiniFiles.open(current_file)
					-- Expand 2 parent directories by going out twice
					MiniFiles.go_out()
					MiniFiles.go_out()
					-- Go back in to show the expanded structure
					MiniFiles.go_in({ close_on_file = false })
					MiniFiles.go_in({ close_on_file = false })
				end,
				desc = "Open Current File with 2 Parent Dirs Expanded",
			},
		},
		config = function()
			local yank_path = function()
				local path = (require("mini.files").get_fs_entry() or {}).path
				if path == nil then
					return vim.notify("Cursor is not on valid entry")
				end

				local relative_path = vim.fn.fnamemodify(path, ":.")
				vim.fn.setreg(vim.v.register, relative_path)
			end

			vim.api.nvim_create_autocmd("User", {
				pattern = "MiniFilesBufferCreate",
				callback = function(args)
					local b = args.data.buf_id
					vim.keymap.set("n", "gy", yank_path, { buffer = b, desc = "Yank path" })
					vim.keymap.set("n", "<C-v>", function()
						local path = (require("mini.files").get_fs_entry() or {}).path
						if path == nil then
							return vim.notify("Cursor is not on valid entry")
						end
						vim.cmd("vsplit " .. vim.fn.fnameescape(path))
					end, { buffer = b, desc = "Open in vertical split" })
				end,
			})
		end,
	},
	-- {
	-- 	"ggandor/leap.nvim",
	-- 	event = "VeryLazy",
	-- 	config = function()
	-- 		require("leap").add_default_mappings()
	-- 		-- Fix 'S' mapping by explicitly setting it after default mappings
	-- 		vim.keymap.set("n", "S", "<Plug>(leap-backward-to)", { desc = "Leap backward" })
	-- 		vim.keymap.set("n", "s", "<Plug>(leap-forward-to)", { desc = "Leap forward" })
	-- 	end,
	-- },
}
