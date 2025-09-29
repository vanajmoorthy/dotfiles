return {
	-- Keymap discovery
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {},
	},

	-- Smooth animations
	{
		"echasnovski/mini.animate",
		event = "VimEnter",
		opts = function()
			local animate = require("mini.animate")
			return {
				-- Disable all animations except scroll
				cursor = { enable = false },
				resize = { enable = false },
				open = { enable = false },
				close = { enable = false },

				-- Configure scroll animation
				scroll = {
					enable = true,
					timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
					-- This subscroll function is the key to targeting only Ctrl+d and Ctrl+u
					subscroll = animate.gen_subscroll.equal({
						predicate = function(total_scroll)
							-- Animate only when the scroll amount is exactly the 'scroll' option value.
							-- This is what Ctrl+d and Ctrl+u use.
							return math.abs(total_scroll) == vim.o.scroll
						end,
					}),
				},
			}
		end,
	},

	-- Add/delete/replace surroundings
	{
		"echasnovski/mini.surround",
		-- NO 'keys' table.
		-- NO 'event' key. This forces it to load on startup.
		config = function()
			-- The setup function handles everything automatically.
			-- All default keymaps (gs, ds, cs) are created here.
			require("mini.surround").setup()
		end,
	},

	-- Bracketed motions
	{
		"echasnovski/mini.bracketed",
		keys = { "[x", "]x", "[", "]" },
		config = function()
			require("mini.bracketed").setup()
		end,
	},

	-- Move lines/blocks
	{
		"echasnovski/mini.move",
		config = function()
			require("mini.move").setup()
		end,
	},
}
