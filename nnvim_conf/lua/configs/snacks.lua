function x()
  -- Toggle the profiler
  Snacks.toggle.profiler():map("<leader>pp")
  -- Toggle the profiler highlights
  Snacks.toggle.profiler_highlights():map("<leader>ph")

  vim.keymap.set("t", "<C-x>", function() Snacks.terminal.toggle() end, { desc = "Toggle Terminal" })
  vim.keymap.set("t", "<C-k>", require('smart-splits').move_cursor_up, { desc = "Toggle Terminal" })

  return {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = true },
    -- notifier = { enabled = true },
    quickfile = { enabled = true },
    lazygit = { enabled = true },
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
    }
    -- statuscolumn = { enabled = true },
    -- words = { enabled = true },
    -- scratch = {
    --   enabled = true,
    --   ft = function()
    --     if vim.bo.buftype == "" and vim.bo.filetype ~= "" then
    --       return vim.bo.filetype
    --     end
    --     return "markdown"
    --   end,
    --   win_by_ft = {
    --     lua = {
    --       keys = {
    --         ["source"] = {
    --           "<cr>",
    --           function(self)
    --             local name = "scratch." ..
    --                 vim.fn.fnamemodify(vim.api.nvim_buf_get_name(self.buf), ":e")
    --             Snacks.debug.run({ buf = self.buf, name = name })
    --           end,
    --           desc = "Source buffer",
    --           mode = { "n", "x" },
    --         },
    --       },
    --     },
    --     rust = {
    --       keys = {
    --         ["source"] = {
    --           "<cr>",
    --           function(self)
    --             -- Get the file extension and create a scratch file name
    --             local name = "scratch." ..
    --                 vim.fn.fnamemodify(vim.api.nvim_buf_get_name(self.buf), ":e")
    --             local file_path = "/tmp/" .. name
    --
    --             -- Save buffer contents to temporary file
    --             local lines = vim.api.nvim_buf_get_lines(self.buf, 0, -1, false)
    --             vim.fn.writefile(lines, file_path)
    --
    --             -- Create output buffer if it doesn't exist
    --             local output_buf = vim.api.nvim_create_buf(false, true)
    --             vim.api.nvim_buf_set_option(output_buf, 'buftype', 'nofile')
    --             vim.api.nvim_buf_set_option(output_buf, 'bufhidden', 'wipe')
    --
    --             -- Compile and run the Rust code
    --             local compile_cmd = "rustc " .. file_path .. " -o /tmp/scratch_rust"
    --             local compile_output = vim.fn.system(compile_cmd)
    --
    --             if vim.v.shell_error ~= 0 then
    --               -- If compilation failed, show the error
    --               vim.api.nvim_buf_set_lines(output_buf, 0, -1, false,
    --                 vim.split(compile_output, "\n"))
    --             else
    --               -- If compilation succeeded, run the program
    --               local run_output = vim.fn.system("/tmp/scratch_rust")
    --               vim.api.nvim_buf_set_lines(output_buf, 0, -1, false, vim.split(run_output, "\n"))
    --             end
    --
    --             -- Get the current window dimensions
    --             local current_win = vim.api.nvim_get_current_win()
    --             local win_config = vim.api.nvim_win_get_config(current_win)
    --             local win_width = vim.api.nvim_win_get_width(current_win)
    --
    --             -- Store original width for restoration
    --             local original_width = win_width
    --
    --             -- Calculate new window sizes
    --             local new_width = math.floor(win_width * 0.5)
    --
    --             -- Resize current window
    --             vim.api.nvim_win_set_width(current_win, new_width)
    --
    --             -- Create new floating window for output
    --             local new_win = vim.api.nvim_open_win(output_buf, true, {
    --               relative = win_config.relative,
    --               win = win_config.win,
    --               width = win_width - new_width,
    --               height = win_config.height,
    --               row = win_config.row,
    --               col = win_config.col + new_width,
    --               style = win_config.style,
    --               border = win_config.border
    --             })
    --
    --             -- Set up autocmd to restore original window size when output window closes
    --             vim.api.nvim_create_autocmd({ "WinClosed" }, {
    --               pattern = tostring(new_win),
    --               callback = function()
    --                 -- Check if the original window still exists
    --                 if vim.api.nvim_win_is_valid(current_win) then
    --                   vim.api.nvim_win_set_width(current_win, original_width)
    --                 end
    --               end,
    --               once = true                         -- Only trigger once
    --             })
    --
    --             -- Clean up temporary files
    --             vim.fn.delete(file_path)
    --             vim.fn.delete("/tmp/scratch_rust")
    --           end,
    --           desc = "Source buffer",
    --           mode = { "n", "x" },
    --         },
    --       },
    --     },
    --   },
    -- },
  }
end

return x
