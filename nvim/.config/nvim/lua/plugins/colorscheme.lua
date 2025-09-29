return {
	"sainnhe/gruvbox-material",
	lazy = false, -- Make sure the theme is loaded on startup
	priority = 1000, -- Load it before other plugins
	config = function()
		-- Set the theme variant you want to use
		-- Options: "hard", "medium", "soft"
		vim.g.gruvbox_material_background = "medium"

		-- You can also change the contrast for more vibrancy
		-- Options: "high", "medium", "low" (default is "medium")
		vim.g.gruvbox_material_contrast = "high"

		-- Load the colorscheme
		vim.cmd.colorscheme("gruvbox-material")
	end,
}
