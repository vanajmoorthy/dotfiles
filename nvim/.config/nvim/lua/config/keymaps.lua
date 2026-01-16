local keymap = vim.keymap

-- Clear search highlights
keymap.set("n", "<esc>", "<cmd>nohlsearch<cr>")

-- Exit terminal mode
keymap.set("t", "<esc><esc>", [[<c-\><c-n>]], { desc = "Exit terminal mode" })

-- Select all text in the file
keymap.set("n", "<C-a>", "ggVG", { desc = "Select all text in file" })

-- Window navigation
keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
keymap.set("n", "<C-j>", "<C-w><c-j>", { desc = "Move focus to the lower window" })
keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Window navigation from terminal mode
keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], { desc = "Move focus to the left window" })
keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], { desc = "Move focus to the right window" })
keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], { desc = "Move focus to the lower window" })
keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], { desc = "Move focus to the upper window" })

-- NvimTree toggle
keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle NvimTree" })

-- Buffer navigation
keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Go to next buffer" })
keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Go to previous buffer" })

-- Buffer reordering
keymap.set("n", "<leader>bl", "<cmd>BufferLineMoveNext<cr>", { desc = "Move buffer right" })
keymap.set("n", "<leader>bh", "<cmd>BufferLineMovePrev<cr>", { desc = "Move buffer left" })

-- Tab management
keymap.set("n", "<leader>tc", "<cmd>tabnew<cr>", { desc = "Create new tab" })
keymap.set("n", "<leader>td", "<cmd>tabclose<cr>", { desc = "Close current tab" })

keymap.set("n", "<leader>x", function()
	-- Don't close NvimTree with this keymap
	if vim.bo.filetype == "NvimTree" or vim.api.nvim_buf_get_name(0):match("NvimTree") then
		vim.notify("Cannot close NvimTree with this keymap.", vim.log.levels.WARN)
		return
	end

	local current_buf = vim.api.nvim_get_current_buf()

	-- Get list of valid buffers (listed, loaded, not NvimTree)
	local buffers = vim.tbl_filter(function(buf)
		if not vim.api.nvim_buf_is_valid(buf) then return false end
		if not vim.bo[buf].buflisted then return false end
		local ft = vim.bo[buf].filetype
		if ft == "NvimTree" or ft == "snacks_picker_list" then return false end
		return true
	end, vim.api.nvim_list_bufs())

	-- If this is the only buffer, just delete it
	if #buffers <= 1 then
		vim.cmd("bdelete")
		return
	end

	-- Find current buffer's position
	local current_idx = nil
	for i, buf in ipairs(buffers) do
		if buf == current_buf then
			current_idx = i
			break
		end
	end

	if not current_idx then
		vim.cmd("bdelete")
		return
	end

	-- Determine target buffer:
	-- If leftmost (idx 1) → go right
	-- Otherwise → go left
	local target_buf
	if current_idx == 1 then
		target_buf = buffers[2] -- go right
	else
		target_buf = buffers[current_idx - 1] -- go left
	end

	-- Switch to target buffer first, then delete current
	vim.api.nvim_set_current_buf(target_buf)
	vim.cmd("bdelete " .. current_buf)
end, { desc = "Close current buffer" })

keymap.set("n", "<leader>tn", "<cmd>tabnext<cr>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabprevious<cr>", { desc = "Go to previous tab" })
