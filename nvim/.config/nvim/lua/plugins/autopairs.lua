return {
	"windwp/nvim-autopairs",
	-- Load this plugin whenever you enter insert mode
	event = "InsertEnter",
	-- Optional dependency for better integration with nvim-cmp
	dependencies = { "hrsh7th/nvim-cmp" },
	config = function()
		local autopairs = require("nvim-autopairs")

		-- Configure the plugin
		autopairs.setup({
			check_ts = true, -- Check treesitter for context before acting
			ts_config = {
				lua = { "string" }, -- Don't add pairs inside lua strings
				javascript = { "template_string" },
				java = false, -- Disable for java
			},
		})

		-- This is the crucial part for integration with nvim-cmp
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		local cmp = require("cmp")

		-- Make sure that when you press <CR> to select a completion,
		-- it confirms the completion and doesn't just insert a newline.
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
	end,
}
