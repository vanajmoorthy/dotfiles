-- ~/.config/nvim/lua/plugins/ui.lua

return {
	-- File explorer
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			vim.opt.fillchars = { eob = " " }
			local function on_attach(bufnr)
				local api = require("nvim-tree.api")

				local function opts(desc)
					return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
				end

				api.config.mappings.default_on_attach(bufnr)

				vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
				vim.keymap.set("n", "o", api.node.open.tab, opts("Open: New Tab"))
			end

			require("nvim-tree").setup({
				sort_by = "case_sensitive",
				on_attach = on_attach,
				update_focused_file = {
					enable = true,
					update_cwd = true,
				},
				view = {
					width = 30,
					side = "left",
				},
				renderer = {
					group_empty = true,
					root_folder_modifier = ":t",
					indent_markers = {
						enable = false,
					},
					icons = {
						show = {
							file = true,
							folder = true,
							folder_arrow = true,
							git = true,
						},
						glyphs = {
							git = {
								unstaged = "✗",
								staged = "✓",
								unmerged = "",
								renamed = "➜",
								untracked = "★",
								deleted = "",
								ignored = "◌",
							},
						},
					},
					highlight_git = true,
				},
				filters = {
					dotfiles = false, -- Show dotfiles
				},
				actions = {
					open_file = {
						quit_on_open = false,
						window_picker = {
							enable = false,
						},
					},
				},
				-- Disable netrw at the very start of init.lua
				disable_netrw = true,
				hijack_netrw = true,
			})
			vim.cmd([[
  highlight NvimTreeGitDirty guifg=#d79921
  highlight NvimTreeGitStaged guifg=#98971a
  highlight NvimTreeGitNew guifg=#d79921
  highlight NvimTreeGitDeleted guifg=#cc241d
  highlight NvimTreeGitRenamed guifg=#458588
  highlight NvimTreeGitUntracked guifg=#b16286
]])
		end,
	},
	-- Icons
	{ "nvim-tree/nvim-web-devicons" },

	-- Tabline
	{
		"akinsho/bufferline.nvim",
		event = "VimEnter",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"tiagovla/scope.nvim", -- Add scope as a dependency
		},
		config = function()
			require("bufferline").setup({
				options = {
					mode = "buffers",
					separator_style = "slant",
					show_buffer_close_icons = true,
					show_close_icon = true,
					sort_by = "insert_at_end", -- New buffers open on the right
					custom_filter = function(buf_number)
						-- Simple filter - scope.nvim handles tab-scoping automatically
						if vim.api.nvim_buf_get_name(buf_number) ~= "" then
							local filetype = vim.bo[buf_number].filetype
							if filetype ~= "NvimTree" and filetype ~= "snacks_picker_list" then
								return true
							end
						end
						return false
					end,
				},
			})
		end,
	},

	-- Statusline
	{ "echasnovski/mini.statusline", event = "VimEnter", config = true },

	-- Indent guides
	{ "lukas-reineke/indent-blankline.nvim", main = "ibl", event = { "BufReadPost", "BufNewFile" }, opts = {} },

	-- Marks
	{ "chentoast/marks.nvim", event = "VimEnter", config = true },

	-- Optional: Minimap
	{ "echasnovski/mini.map", event = "VimEnter", config = true },
}
