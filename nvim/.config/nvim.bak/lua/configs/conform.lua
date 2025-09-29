-- lua/configs/conform.lua
local options = {
	formatters_by_ft = {
		lua = { "stylua" }, -- Example if you install stylua via Mason
		css = { "prettier" },
		html = { "prettier" },
		javascript = { "prettier" },
		htmldjango = { "prettier" },
		typescript = { "prettier" },
		typescriptreact = { "prettier" },
		javascriptreact = { "prettier" },
		json = { "prettier" }, -- Add other types prettier supports
		yaml = { "prettier" },
		markdown = { "prettier" },
		python = { "isort", "black" },
		terraform = { "terraform_fmt" },
		-- Add go if needed, ensure gofmt/goimports are installed via Mason
		-- go = { "gofmt", "goimports" },
	},

	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 3000,
		lsp_fallback = false, -- IMPORTANT: If conform doesn't have a formatter, try LSP (like tsserver)
	},

	-- Optional: Add configuration for specific formatters if needed
	-- formatters = {
	--   prettier = {
	--      args = { "--config", "/path/to/your/.prettierrc" } -- Only if needed
	--   }
	-- }
}

require("conform").setup(options)

-- Return the options table (optional, but can be useful for debugging/chaining)
return options
