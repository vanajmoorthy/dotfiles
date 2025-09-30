return {
	"numToStr/Comment.nvim",
	-- Or, for better startup performance, load it after starting up
	-- event = "VeryLazy",
	config = function()
		require("Comment").setup()

		-- This is the key part that adds the mapping you want
		vim.keymap.set(
			-- The modes to set the keymap in
			-- 'n' for normal mode, 'v' for visual mode
			{ "n", "v" },

			-- The key sequence to map
			"<leader>/",

			-- The function to execute
			-- This uses the plugin's API to toggle comments linewise
			function()
				require("Comment.api").toggle.linewise.current()
			end,

			-- Options for the keymap
			{
				desc = "Toggle comment", -- A description for which-key
			}
		)
	end,
}
