return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" }, -- Load on save
		cmd = { "ConformInfo" }, -- Load when command is run
		opts = {}, -- NvChad might pass options here, or you load your config file
		config = function()
			-- If your config is in lua/configs/conform.lua, require it here:
			require("configs.conform")
			-- OR, put the setup directly here if not using a separate file
		end,
	},

	-- These are some examples, uncomment them if you want to see them work!
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("configs.lspconfig")
		end,
	},

	{
		"ray-x/lsp_signature.nvim",
		event = "VeryLazy",
		config = function()
			require("lsp_signature").setup({
				bind = false,
				floating_window = true, -- Show function signatures in floating window
				hint_enable = false, -- Disable inline hints (optional)
				handler_opts = { border = "rounded" },
			})
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		opts = {
			git = {
				enable = true,
				timeout = 2000, -- bump timeout (default is 400ms)
			},
			renderer = {
				highlight_git = true,
			},
		},
	},
	{
		"windwp/nvim-autopairs",
		enabled = true,
	},

	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local harpoon = require("harpoon")
			-- REQUIRED - just setup, keymaps are handled in mappings.lua
			harpoon:setup({
				settings = {
					save_on_toggle = true,
					sync_on_ui_close = true,
				},
			})
		end,
	},

	-- {
	-- 	"nvim-treesitter/nvim-treesitter",
	-- 	opts = {
	-- 		ensure_installed = {
	-- 			"vim", "lua", "vimdoc",
	--      "html", "css"
	-- 		},
	-- 	},
	-- },
}
