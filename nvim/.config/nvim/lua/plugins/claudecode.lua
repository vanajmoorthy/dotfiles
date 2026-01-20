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
					-- Accept the diff
					local diff = require("claudecode.diff")
					diff.accept_current_diff()
					-- Clean up diff buffers after a short delay to let the accept complete
					vim.defer_fn(function()
						diff._cleanup_diff_state(tab_name, "manual accept")
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
					-- Deny and clean up
					local diff = require("claudecode.diff")
					diff.deny_current_diff()
					vim.defer_fn(function()
						diff._cleanup_diff_state(tab_name, "manual deny")
					end, 100)
				end,
				desc = "Deny diff",
			},
		},
	},
}
