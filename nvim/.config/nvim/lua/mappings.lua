require("nvchad.mappings")

local map = vim.keymap.set

map("i", "jk", "<ESC>")

map("n", "<C-d>", "<C-d>zz", { desc = "Center cursor after moving down half-page" })

map("n", "<leader>d#", [[:%s/#.*//g<CR>]], { desc = "Delete all inline Python comments" })

map("n", "<leader>d/", [[:silent! %s#//.*$##g<CR>]], { desc = "Delete all inline JS comments (//...)" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
map("n", "<leader>fm", function()
	require("conform").format({ async = true, lsp_fallback = true }) -- Or just { async = true } if you always want conform
end, { desc = "Format with Conform" })
