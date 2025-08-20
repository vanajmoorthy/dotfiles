vim.g.base46_cache = vim.fn.stdpath("data") .. "/nvchad/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
	local repo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath })
end

vim.opt.rtp:prepend(lazypath)
vim.wo.relativenumber = true

local lazy_config = require("configs.lazy")

-- load plugins
require("lazy").setup({
	{
		"NvChad/NvChad",
		lazy = false,
		branch = "v2.5",
		import = "nvchad.plugins",
	},

	{ import = "plugins" },

	-- Mason setup to install Prettier
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					-- Formatters
					"prettier", -- Keep this for conform.nvim
					"stylua", -- Add if you use it for Lua (conform example)
					"gofmt", -- Add if using Go (conform example)
					"goimports", -- Add if using Go (conform example)
					"black",
					"isort",
					"terraform_fmt",

					-- LSPs
					"gopls",
					"denols",
					"emmet_ls",
					"tailwindcss", -- Add this
					"tsserver", -- Add this (Mason's name for typescript-language-server)
					"eslint", -- Add this (Or eslint_d if you prefer)
					"html", -- Add this
					"cssls", -- Add this
					"pyright",
					"flake8",
					"terraformls",

					-- Add any other linters/formatters/LSPs you use here
				},
				-- Optional: Add automatic_installation = true if you want Mason to automatically install listed servers if missing
				-- automatic_installation = true,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		vscode = true,
		---@type Flash.Config
		-- *** ADD/MODIFY THIS 'opts' TABLE ***
		opts = {
			modes = {
				-- This disables flash for f, F, t, and T
				char = {
					enabled = false,
				},
			},
		},
    -- stylua: ignore
    keys = {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "S",     mode = { "n", "o", "x" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
	},
	{
		"unblevable/quick-scope",
		event = "VeryLazy",
		config = function()
			-- This line enables highlighting for f, F, t, and T motions
			vim.g.qs_highlight_on_keys = { "f", "F", "t", "T" }

			-- Highlight for the first character match
			vim.api.nvim_set_hl(0, "QuickScopePrimary", {
				fg = "yellow",
				bold = true,
			})

			-- Highlight for the second character match
			vim.api.nvim_set_hl(0, "QuickScopeSecondary", {
				fg = "cyan",
				bold = true,
			})
		end,
	},
}, lazy_config)

require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"typescript",
		"tsx",
		"python",
		"lua",
		"vim",
		"vimdoc",
		"json",
		"yaml",
		"html",
		"css",
		"markdown",
		"terraform",
		"hcl",
		"htmldjango",
	},
	highlight = {
		enable = true,
	},
	indent = { enable = true },
})

require("telescope").setup({
	defaults = {
		file_ignore_patterns = {
			"node_modules",
		},
	},
})

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require("options")
require("nvchad.autocmds")

vim.keymap.set("n", "<leader>a", 'ggVG"+y', { noremap = true, silent = true })

vim.schedule(function()
	require("mappings")
end)

vim.api.nvim_create_autocmd("BufDelete", {
	callback = function()
		local bufs = vim.t.bufs
		if #bufs == 1 and vim.api.nvim_buf_get_name(bufs[1]) == "" then
			vim.cmd("Nvdash")
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	callback = function()
		vim.opt.autoindent = true
		vim.opt.smartindent = true
		vim.opt.tabstop = 4
		vim.opt.shiftwidth = 4
		vim.opt.expandtab = true
	end,
})

vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldenable = true
vim.o.foldlevel = 99
