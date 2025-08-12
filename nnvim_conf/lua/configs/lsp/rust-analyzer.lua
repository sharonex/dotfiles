local expandMacro = function()
	vim.lsp.buf_request_all(0, "rust-analyzer/expandMacro", vim.lsp.util.make_position_params(), function(result)
		-- Create a new tab
		vim.cmd("vsplit")
		vim.inspect(result)

		-- Create an empty scratch buffer (non-listed, non-file i.e scratch)
		-- :help nvim_create_buf
		local buf = vim.api.nvim_create_buf(false, true)

		-- and set it to the current window
		-- :help nvim_win_set_buf
		vim.api.nvim_win_set_buf(0, buf)

		if result then
			-- set the filetype to rust so that rust's syntax highlighting works
			-- :help nvim_set_option_value
			vim.api.nvim_set_option_value("filetype", "rust", { buf = 0 })

			-- Insert the result into the new buffer
			for client_id, res in pairs(result) do
				if res and res.result and res.result.expansion then
					-- :help nvim_buf_set_lines
					vim.api.nvim_buf_set_lines(buf, -1, -1, false, vim.split(res.result.expansion, "\n"))
				else
					vim.api.nvim_buf_set_lines(buf, -1, -1, false, {
						"No expansion available.",
					})
				end
			end
		else
			vim.api.nvim_buf_set_lines(buf, -1, -1, false, {
				"Error: No result returned.",
			})
		end
	end)
end

-- Create a user command that calls this function
vim.api.nvim_create_user_command("ExpandMacro", function()
	expandMacro()
end, {})

-- Is this still required?
for _, method in ipairs({ "textDocument/diagnostic", "workspace/diagnostic" }) do
	local default_diagnostic_handler = vim.lsp.handlers[method]
	vim.lsp.handlers[method] = function(err, result, context, config)
		if err ~= nil and err.code == -32802 then
			return
		end
		return default_diagnostic_handler(err, result, context, config)
	end
end

-- Track current check mode state
local check_mode = "clippy" -- Start with clippy as default

-- Function to toggle between clippy and check
local function toggle_check_mode()
	local new_mode = check_mode == "clippy" and "check" or "clippy"
	check_mode = new_mode

	-- Update rust-analyzer settings
	local new_settings = {
		["rust-analyzer"] = {
			checkOnSave = true,
			check = {
				command = new_mode,
			},
		},
	}

	-- Get the rust-analyzer client
	local clients = vim.lsp.get_clients({ name = "rust_analyzer" })
	if #clients > 0 then
		local client = clients[1]
		-- Update client settings
		client.config.settings = vim.tbl_deep_extend("force", client.config.settings or {}, new_settings)
		-- Notify the server of the configuration change
		client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
		print("Rust analyzer check mode switched to: " .. new_mode)
	else
		print("No active rust-analyzer client found")
	end
end

-- Your original rust-analyzer setup with the toggle function added
require("lspconfig").rust_analyzer.setup({
	-- capabilities = capabilities,
	cmd = { "rustup", "run", "stable", "rust-analyzer" },
	settings = {
		["rust-analyzer"] = {
			checkOnSave = true,
			check = {
				command = "check", -- Default to check
			},
		},
	},
	commands = {
		ExpandMacro = {
			expandMacro,
		},
		-- Add the toggle command
		ToggleCheckMode = {
			toggle_check_mode,
			description = "Toggle between clippy and check mode",
		},
	},
})

-- Optional: Create a vim command for easier access
vim.api.nvim_create_user_command("RustToggleCheck", toggle_check_mode, {
	desc = "Toggle rust-analyzer between clippy and check mode",
})

vim.keymap.set("n", "<leader>xc", ":RustToggleCheck<CR>", { desc = "Toggle Rust check mode" })
