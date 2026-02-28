vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { noremap = true })
vim.keymap.set("n", "<leader>fo", ":Oil<CR>", { noremap = true })
vim.keymap.set("n", "<leader>tt", ":ToggleTerm<cr>", { noremap = true, silent = true })
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { noremap = true, silent = true })

