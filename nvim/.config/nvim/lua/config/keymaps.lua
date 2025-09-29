local keymap = vim.keymap

-- Clear search highlights
keymap.set("n", "<esc>", "<cmd>nohlsearch<cr>")

-- Exit terminal mode
keymap.set("t", "<esc><esc>", [[<c-\><c-n>]], { desc = "Exit terminal mode" })

-- Copy entire file to clipboard
keymap.set("n", "<leader>a", 'ggVG"+y', { desc = "Select and copy all text in file" })

-- Window navigation
keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
keymap.set("n", "<C-j>", "<C-w><c-j>", { desc = "Move focus to the lower window" })
keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- NvimTree toggle
keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle NvimTree" })

-- Buffer navigation
keymap.set("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Go to next buffer" })
keymap.set("n", "<S-Tab>", "<cmd>bprevious<cr>", { desc = "Go to previous buffer" })

-- Tab management
keymap.set("n", "<leader>tc", "<cmd>tabnew<cr>", { desc = "Create new tab" })
keymap.set("n", "<leader>td", "<cmd>tabclose<cr>", { desc = "Close current tab" })

keymap.set("n", "<leader>x", function()
	if vim.bo.filetype == "NvimTree" or vim.api.nvim_buf_get_name(0):match("NvimTree") then
		vim.notify("Cannot close NvimTree with this keymap.", vim.log.levels.WARN)
	else
		vim.cmd("bdelete")
	end
end, { desc = "Close current buffer" })

keymap.set("n", "<leader>tn", "<cmd>tabnext<cr>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabprevious<cr>", { desc = "Go to previous tab" })
