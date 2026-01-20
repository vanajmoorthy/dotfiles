return {
	{
		"coder/claudecode.nvim",
		dependencies = { "folke/snacks.nvim" },
		config = true,
		keys = {
			{ "<leader>a", nil, desc = "AI/Claude Code" },
			{ "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
			{ "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
			{ "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
			{ "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
			{ "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
			{ "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
			{ "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
			{
				"<leader>as",
				"<cmd>ClaudeCodeTreeAdd<cr>",
				desc = "Add file",
				ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
			},
			-- Diff management (with auto-cleanup)
			{
				"<leader>aa",
				function()
					local current_buf = vim.api.nvim_get_current_buf()
					local tab_name = vim.b[current_buf].claudecode_diff_tab_name
					if not tab_name then
						vim.notify("No active diff found in current buffer", vim.log.levels.WARN)
						return
					end
					-- Get diff data to find the original buffer
					local diff = require("claudecode.diff")
					local diff_data = diff._get_active_diffs()[tab_name]
					local original_buf = diff_data and diff_data.original_buffer
					local file_path = diff_data and diff_data.old_file_path

					-- Accept the diff
					diff.accept_current_diff()

					-- Clean up diff buffers after a short delay
					vim.defer_fn(function()
						diff._cleanup_diff_state(tab_name, "manual accept")
						-- Also close the original file buffer from the diff view
						if original_buf and vim.api.nvim_buf_is_valid(original_buf) then
							pcall(vim.api.nvim_buf_delete, original_buf, { force = true })
						end
						-- If file was reloaded into another buffer, close that too
						if file_path then
							local bufnr = vim.fn.bufnr(file_path)
							if bufnr ~= -1 and vim.api.nvim_buf_is_valid(bufnr) then
								pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
							end
						end
					end, 100)
				end,
				desc = "Accept diff",
			},
			{
				"<leader>ad",
				function()
					local current_buf = vim.api.nvim_get_current_buf()
					local tab_name = vim.b[current_buf].claudecode_diff_tab_name
					if not tab_name then
						vim.notify("No active diff found in current buffer", vim.log.levels.WARN)
						return
					end
					-- Get diff data to find the original buffer
					local diff = require("claudecode.diff")
					local diff_data = diff._get_active_diffs()[tab_name]
					local original_buf = diff_data and diff_data.original_buffer

					-- Deny and clean up
					diff.deny_current_diff()

					vim.defer_fn(function()
						diff._cleanup_diff_state(tab_name, "manual deny")
						-- Also close the original file buffer from the diff view
						if original_buf and vim.api.nvim_buf_is_valid(original_buf) then
							pcall(vim.api.nvim_buf_delete, original_buf, { force = true })
						end
					end, 100)
				end,
				desc = "Deny diff",
			},
		},
	},
}
