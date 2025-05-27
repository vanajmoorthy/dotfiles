require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<C-d>", "<C-d>zz", { desc = "Center cursor after moving down half-page" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
map("n", "<leader>fm", function()
  require("conform").format { async = true, lsp_fallback = true } -- Or just { async = true } if you always want conform
end, { desc = "Format with Conform" })
