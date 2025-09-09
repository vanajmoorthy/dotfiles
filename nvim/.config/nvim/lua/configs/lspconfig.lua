-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require("lspconfig")

local nvlsp = require("nvchad.configs.lspconfig")

local on_attach_no_format = function(client, bufnr)
	-- First, run the default NvChad on_attach to get all the keymaps and other setup
	require("nvchad.configs.lspconfig").on_attach(client, bufnr)

	-- THIS IS THE IMPORTANT PART:
	-- Disable formatting capabilities from this language server.
	-- This forces Neovim to use 'conform.nvim' instead.
	client.server_capabilities.documentFormattingProvider = false
	client.server_capabilities.documentRangeFormattingProvider = false
end

lspconfig.denols.setup({
	cmd = { "deno", "lsp" },
	cmd_env = { NO_COLOR = true },
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "typescript.tsx" },
	root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
	settings = {
		deno = {
			enable = true,
			suggest = {
				imports = {
					hosts = {
						["https://deno.land"] = true,
					},
				},
			},
		},
	},
})

lspconfig.pyright.setup({
	on_attach = on_attach_no_format,
	capabilities = nvlsp.capabilities,
	settings = {
		python = {
			analysis = {
				typeCheckingMode = "off", -- "basic" or "strict" if you want type checking
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				diagnosticMode = "workspace",
			},
		},
	},
})

lspconfig.gopls.setup({
	on_attach = nvlsp.on_attach,
	capabilities = nvlsp.capabilities,
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_dir = lspconfig.util.root_pattern("go.mod", ".git"),
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
		},
	},
})

-- Tailwind CSS LSP Setup
lspconfig.tailwindcss.setup({
	on_attach = nvlsp.on_attach,
	capabilities = nvlsp.capabilities,
	filetypes = {
		"html",
		"css",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"svelte",
		"vue",
		"php",
		"blade",
		"htmldjango",
	},
	init_options = {
		userLanguages = {
			blade = "html", -- Example for Laravel Blade
		},
	},
	settings = {
		tailwindCSS = {
			colorDecorators = false,
			experimental = {
				classRegex = {
					"class[s]*Name", -- Adjust regex for your framework (e.g., React className)
				},
			},
		},
	},
})
-- Configure tsserver
lspconfig.ts_ls.setup({
	on_attach = nvlsp.on_attach,
	on_init = nvlsp.on_init,
	capabilities = nvlsp.capabilities,
	root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json"),
	single_file_support = false, -- Prevents conflicts with denols
})

-- Configure eslint
lspconfig.eslint.setup({
	on_attach = nvlsp.on_attach,
	on_init = nvlsp.on_init,
	capabilities = nvlsp.capabilities,
	root_dir = lspconfig.util.root_pattern(".eslintrc", ".eslintrc.json", ".eslintrc.js"),
})

lspconfig.emmet_ls.setup({
	on_attach = nvlsp.on_attach,
	capabilities = nvlsp.capabilities,
	filetypes = {
		"html",
		"css",
		"javascriptreact",
		"typescriptreact",
		"blade",
		"svelte",
		"vue",
	},
	init_options = {
		html = {
			options = {
				["bem.enabled"] = true,
			},
		},
	},
})

lspconfig.terraformls.setup({
	on_attach = nvlsp.on_attach,
	on_init = nvlsp.on_init,
	capabilities = nvlsp.capabilities,
	filetypes = { "terraform" },
	root_dir = lspconfig.util.root_pattern(".terraform", ".git"),
})

-- Default setup for other servers
local servers = { "html", "cssls" }

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_attach = nvlsp.on_attach,
		on_init = nvlsp.on_init,
		capabilities = nvlsp.capabilities,
	})
end
