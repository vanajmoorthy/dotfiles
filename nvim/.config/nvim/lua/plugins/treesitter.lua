return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			-- A list of parser names, or "all"
			-- Add "python" to this list
			ensure_installed = {
				"c",
				"lua",
				"vim",
				"vimdoc",
				"query",
				"javascript",
				"typescript",
				"html",
				"css",
				"json",
				"yaml",
				"markdown",
				"markdown_inline",
				"bash",
				"python", -- Make sure 'python' is in this list
				-- Add any other languages you use here
			},

			-- Install parsers synchronously (blocks startup until installed)
			sync_install = false,

			-- Automatically install missing parsers when entering a buffer
			auto_install = true,

			highlight = {
				enable = true, -- Enable syntax highlighting
			},

			indent = {
				enable = true, -- Enable better indentation
			},
		})
	end,
}
