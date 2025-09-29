-- ~/.config/nvim/lua/plugins/lsp-signature.lua
return {
	{
		"ray-x/lsp_signature.nvim",
		event = "VeryLazy",
		opts = {
			bind = true,
			handler_opts = {
				border = "rounded",
			},
			floating_window = true,
			hint_enable = false, -- Disable virtual text hints
			hi_parameter = "LspSignatureActiveParameter",
		},
		config = function(_, opts)
			require("lsp_signature").setup(opts)
		end,
	},
}
