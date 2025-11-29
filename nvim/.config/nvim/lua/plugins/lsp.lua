-- ~/.config/nvim/lua/plugins/lsp.lua

return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"stevearc/conform.nvim",
			"mfussenegger/nvim-lint",
			"sheerun/vim-polyglot",
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "ts_ls", "html", "cssls", "pyright", "eslint", "tailwindcss" },
				handlers = {
					function(server_name) -- default handler
						lspconfig[server_name].setup({
							capabilities = capabilities,
						})
					end,
					["html"] = function()
						lspconfig.html.setup({
							capabilities = capabilities,
							filetypes = { "html", "htmldjango" }, -- Add "htmldjango" here
						})
					end,
					["eslint"] = function()
						lspconfig.eslint.setup({
							capabilities = capabilities,
							settings = {
								-- Disable the eslint formatter
								format = false,
							},
						})
					end,
					["ts_ls"] = function()
						lspconfig.ts_ls.setup({
							capabilities = capabilities,
							-- This is the crucial part
							on_attach = function(client, bufnr)
								-- Disable LSP formatting capabilities to prevent conflicts with conform
								client.server_capabilities.documentFormattingProvider = false
								client.server_capabilities.documentRangeFormattingProvider = false
							end,
						})
					end,
					["lua_ls"] = function()
						lspconfig.lua_ls.setup({
							capabilities = capabilities,
							settings = {
								Lua = {
									runtime = { version = "LuaJIT" },
									workspace = {
										library = vim.api.nvim_get_runtime_file("", true),
										checkThirdParty = false,
									},
									telemetry = { enable = false },
									format = { enable = false },
								},
							},
						})
					end,
					["tailwindcss"] = function()
						lspconfig.tailwindcss.setup({
							capabilities = capabilities,
							filetypes = { "html", "javascript", "typescript", "react", "vue", "css" },
						})
					end,
				},
			})

			-- LSP keymaps on attach
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local opts = { buffer = ev.buf }
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
					vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
					vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
					vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
				end,
			})

			-- Setup nvim-cmp
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			require("luasnip.loaders.from_vscode").lazy_load()

			-- Helper function for tab behavior
			local has_words_before = function()
				unpack = unpack or table.unpack
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
					and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					-- Tab to cycle forward through completions and snippets
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						elseif has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end, { "i", "s" }),
					-- Shift-Tab to cycle backward
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
				}),
			})

			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "black" },
					htmldjango = { "djlint" },
					javascript = { "prettier" },
					typescript = { "prettier" },
					javascriptreact = { "prettier" },
					typescriptreact = { "prettier" },
					css = { "prettier" },
					html = { "prettier" },
					json = { "prettier" },
					yaml = { "prettier" },
					markdown = { "prettier" },
				},
				format_on_save = function(bufnr)
					-- Disable autoformat for files in node_modules
					local bufname = vim.api.nvim_buf_get_name(bufnr)
					if bufname:match("/node_modules/") then
						return
					end
					return {
						timeout_ms = 2000, -- Increased timeout
						lsp_fallback = true,
					}
				end,
				formatters = {
					djlint = {
						-- Tells djlint to also format CSS and JS within the template
						args = { "--reformat", "--format-css", "-" },
					},
					prettier = {
						-- By default, conform will run formatters from the project root.
						-- This explicitly tells prettier to run from the file's directory,
						-- allowing it to find the nearest .prettierrc.
						-- However, a better approach for monorepos is to use `cwd`.
						cwd = require("conform.util").root_file({
							".prettierrc",
							".prettierrc.json",
							".prettierrc.js",
							"prettier.config.js",
							"package.json",
							".git", -- Good fallback for project root
						}),
					},
				},
			})

			-- Manual format keymap
			vim.keymap.set({ "n", "v" }, "<leader>fm", function()
				require("conform").format({
					lsp_fallback = true,
					async = false,
					timeout_ms = 2000,
				})
			end, { desc = "Format file or range" })

			-- Setup linting (disabled by default - only enable what you need)
			require("lint").linters_by_ft = {
				-- python = { "pylint" },  -- Comment this out if you don't have pylint
			}
			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
	},
}
