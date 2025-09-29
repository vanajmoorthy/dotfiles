require("nvchad.mappings")

local map = vim.keymap.set
local del = vim.keymap.del

del("n", "<leader>h")

local builtin = require("telescope.builtin")

-- Override gd to use Telescope's LSP definitions picker
map("n", "gd", builtin.lsp_definitions, { desc = "LSP Definitions (Telescope)" })

map("i", "jk", "<ESC>")

map("n", "<C-d>", "<C-d>zz", { desc = "Center cursor after moving down half-page" })

map("n", "<leader>d#", [[:%s/#.*//g<CR>]], { desc = "Delete all inline Python comments" })

map("n", "<leader>d/", [[:silent! %s#//.*$##g<CR>]], { desc = "Delete all inline JS comments (//...)" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
map("n", "<leader>fm", function()
	require("conform").format({ async = true, lsp_fallback = true }) -- Or just { async = true } if you always want conform
end, { desc = "Format with Conform" })

local harpoon = require("harpoon")

-- Basic Harpoon operations
map("n", "<leader>ha", function()
	harpoon:list():add()
end, { desc = "Harpoon add file" })

map("n", "<leader>hh", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon quick menu" })

-- Remove operations
map("n", "<leader>hr", function()
	harpoon:list():remove()
end, { desc = "Harpoon remove current file" })

map("n", "<leader>hc", function()
	harpoon:list():clear()
end, { desc = "Harpoon clear all" })

-- Quick navigation to harpooned files
map("n", "<leader>h1", function()
	harpoon:list():select(1)
end, { desc = "Harpoon file 1" })

map("n", "<leader>h2", function()
	harpoon:list():select(2)
end, { desc = "Harpoon file 2" })

map("n", "<leader>h3", function()
	harpoon:list():select(3)
end, { desc = "Harpoon file 3" })

map("n", "<leader>h4", function()
	harpoon:list():select(4)
end, { desc = "Harpoon file 4" })

-- Navigate to next & previous buffers in harpoon list
map("n", "<C-S-P>", function()
	harpoon:list():prev()
end, { desc = "Harpoon prev" })

map("n", "<C-S-N>", function()
	harpoon:list():next()
end, { desc = "Harpoon next" })

-- Optional: Add terminal mappings back with different keys
map("n", "<leader>tt", function()
	require("nvchad.term").toggle({ pos = "sp", id = "htoggleTerm" })
end, { desc = "Terminal horizontal" })

map("n", "<leader>tv", function()
	require("nvchad.term").toggle({ pos = "vsp", id = "vtoggleTerm" })
end, { desc = "Terminal vertical" })

map("n", "<leader>tf", function()
	require("nvchad.term").toggle({ pos = "float", id = "floatTerm" })
end, { desc = "Terminal float" })
