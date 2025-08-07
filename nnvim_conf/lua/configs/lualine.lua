-- LSP clients attached to buffer
local function is_not_toggleterm()
	return vim.bo.filetype ~= "toggleterm"
end

local function is_toggleterm()
	return vim.bo.filetype == "toggleterm"
end

local function get_words()
	local wc = vim.fn.wordcount()
	if wc["visual_words"] then -- text is selected in visual mode
		return wc["visual_words"] .. " Words/" .. wc["visual_chars"] .. " Chars (Vis)"
	else -- all of the document
		return wc["words"] .. " Words"
	end
end

local function is_text_file()
	local ft = vim.opt_local.filetype:get()
	local count = {
		latex = true,
		tex = true,
		text = true,
		markdown = true,
		vimwiki = true,
	}
	return count[ft] ~= nil
end

local function get_term_name()
	local terms = require("toggleterm.terminal").get_all()
	for _, term in ipairs(terms) do
		if vim.fn.win_id2win(term.window) == vim.fn.winnr() then
			local session_terms = require("workspaces.toggleterms").get_session_terms()
			local prefix
			local term_display_id
			for _, value in ipairs(session_terms) do
				if value.global_id == term.id then
					term_display_id = value.local_id
				end
			end

			if next(vim.fn.argv()) ~= nil then
				prefix = "toggleterm"
			else
				local workspace = require("workspaces.state").get().current_workspace
				prefix = workspace.name .. "-" .. workspace.current_session_name
			end

			return prefix .. ": Term " .. term_display_id
		end
	end
end

local function get_plugin_info()
	local stats = require("lazy").stats()
	return "󰚥 " .. stats.loaded .. "/" .. stats.count
end

local function get_startup_time()
	local stats = require("lazy").stats()
	return "󰅕 " .. stats.startuptime .. "ms"
end

require("lualine").setup(
	---@module 'lualine'
	{
		options = {
			always_divide_middle = false,
			section_separators = { left = "", right = "" },
			component_separators = { left = "", right = "" },
		},
		sections = {
			lualine_a = { { "mode", cond = is_not_toggleterm }, { get_term_name, cond = is_toggleterm } },
			lualine_b = {
				{ get_words, cond = is_text_file },
				{ "branch", icon = "" },
				"diagnostics",
			},
			lualine_c = { { get_plugin_info }, { get_startup_time } },
			lualine_x = { { "filesize", cond = is_not_toggleterm }, { "filetype", cond = is_not_toggleterm } },
			lualine_y = {
				{ "progress", cond = is_not_toggleterm },
				{ "location", cond = is_not_toggleterm },
			},
		},
		extensions = {
			"mason",
			"lazy",
			"trouble",
		},
	}
)
