return {
	"lewis6991/gitsigns.nvim",
	-- This is a performance optimization.
	-- The plugin will only load when you open a file, not on startup.
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("gitsigns").setup({
			-- You can customize the signs here if you want
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
				untracked = { text = "▎" },
			},

			-- This is the key part: defining keymaps for interactivity
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				-- Use ]c and [c to jump between hunks.
				-- It's convenient to also add these mappings to visual and operator-pending modes.
				map({ "n", "v" }, "]c", function()
					if vim.wo.diff then
						return "]c"
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, desc = "Jump to next Git hunk" })

				map({ "n", "v" }, "[c", function()
					if vim.wo.diff then
						return "[c"
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, desc = "Jump to previous Git hunk" })

				-- Actions
				-- These are the most useful actions.
				-- <leader>hs stages the current hunk.
				-- <leader>hr resets (undoes) the current hunk.
				-- <leader>hp previews the hunk's changes in a floating window.
				map("n", "<leader>hs", gs.stage_hunk, { desc = "[g]it [s]tage hunk" })
				map("n", "<leader>hr", gs.reset_hunk, { desc = "[g]it [r]eset hunk" })
				map("v", "<leader>hs", function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "[g]it [s]tage hunk" })
				map("v", "<leader>hr", function()
					gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "[g]it [r]eset hunk" })
				map("n", "<leader>hp", gs.preview_hunk, { desc = "[g]it [p]review hunk" })
				map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "[g]it [u]ndo stage hunk" })
			end,
		})
	end,
}
