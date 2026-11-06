local opt = vim.opt

-- Set clipboard to use system clipboard
opt.clipboard = "unnamedplus"

-- Basic editor settings
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.mouse = "a"
opt.breakindent = true
opt.undofile = true
opt.ignorecase = true
opt.smartcase = true
opt.updatetime = 250
opt.timeoutlen = 300
opt.splitright = true
opt.splitbelow = true

-- Tab and indentation settings
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4

-- Search settings
opt.hlsearch = true
opt.incsearch = true

-- Appearance
opt.termguicolors = true
opt.signcolumn = "yes"

vim.diagnostic.config({
	virtual_text = {
		prefix = "●", -- Could be '■', '▎', 'x', '●'
		spacing = 4,
		source = "if_many",
	},
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
})

-- Custom diagnostic signs (modern method)
vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.HINT] = " ",
			[vim.diagnostic.severity.INFO] = " ",
		},
	},
})

-- vim-polyglot's TS ftplugin does a global `set path+=node_modules/**`, so gf on an
-- aliased import (e.g. 'Modules/Agents') crawls all of node_modules and hangs.
-- Look in cwd-relative src/ and App/ (tsconfig baseUrl) instead, and resolve dir imports to index files.
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	callback = function()
		vim.opt.path = ".,,src,App"
		vim.opt_local.suffixesadd =
			{ ".ts", ".tsx", ".js", ".jsx", "/index.ts", "/index.tsx", "/index.js", "/index.jsx" }
		vim.opt_local.includeexpr = ""
		-- plain gf accepts the bare directory before trying suffixes; findfile skips dirs
		vim.keymap.set("n", "gf", function()
			local f = vim.fn.findfile(vim.fn.expand("<cfile>"))
			if f == "" then
				return vim.notify("No file found for " .. vim.fn.expand("<cfile>"), vim.log.levels.WARN)
			end
			vim.cmd.edit(f)
		end, { buffer = true })
	end,
})
