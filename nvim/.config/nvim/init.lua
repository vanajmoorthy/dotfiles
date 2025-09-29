-- Set <space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Install package manager (lazy.nvim)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Load basic configuration
require("config.options")
require("config.keymaps")

-- Load plugins with lazy.nvim
require("lazy").setup({
	spec = {
		-- This is the correct way to load from the plugins/ directory
		{ import = "plugins" },
	},
	change_detection = {
		notify = false,
	},
})
