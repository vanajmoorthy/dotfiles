return {
	"numToStr/Comment.nvim",
	-- Or, for better startup performance, load it after starting up
	-- event = "VeryLazy",
	config = function()
		require("Comment").setup()

		-- Normal mode: toggle comment on current line
		vim.keymap.set("n", "<leader>/", function()
			require("Comment.api").toggle.linewise.current()
		end, { desc = "Toggle comment" })

		-- Visual mode: toggle comment on selected lines
		vim.keymap.set(
			"v",
			"<leader>/",
			"<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
			{
				desc = "Toggle comment",
			}
		)
	end,
}
