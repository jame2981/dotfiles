local map = function(mode, keys, cmd, desc)
    vim.keymap.set(mode, keys, cmd, { noremap = true, silent = true, desc = desc })
end

-- Terminal
map("n", "<leader>tt", ":ToggleTerm<cr>", "Toggle Terminal")
map("t", "<Esc>", "<C-\\><C-n>", "Exit Terminal Mode")

-- Window navigation
map("n", "<C-h>", "<C-w>h", "Move to Left Window")
map("n", "<C-l>", "<C-w>l", "Move to Right Window")
map("n", "<C-j>", "<C-w>j", "Move to Below Window")
map("n", "<C-k>", "<C-w>k", "Move to Above Window")

-- Buffer navigation
map("n", "<leader>bd", ":bdelete<cr>", "Delete Buffer")
map("n", "<Tab>", ":bnext<cr>", "Next Buffer")
map("n", "<S-Tab>", ":bprevious<cr>", "Prev Buffer")

-- File tree
map("n", "<leader>e", ":NvimTreeToggle<cr>", "Toggle File Tree")

-- Save
map("n", "<leader>w", ":w<cr>", "Save File")
map("n", "<leader>q", ":q<cr>", "Quit")

-- Git (diffview)
map("n", "<leader>gd", ":DiffviewOpen<cr>", "Git Diff")
map("n", "<leader>gh", ":DiffviewFileHistory %<cr>", "Git File History")
map("n", "<leader>gc", ":DiffviewClose<cr>", "Close Diffview")

