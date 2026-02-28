return {
  "augmentcode/augment.vim",
  init = function()
    vim.g.augment_workspace_folders = { "~/code" }
  end,
  keys = {
    { "<leader>ac", ":Augment chat<CR>",        mode = { "n", "v" }, desc = "Augment chat" },
    { "<leader>an", ":Augment chat-new<CR>",    mode = "n",          desc = "Augment chat new" },
    { "<leader>at", ":Augment chat-toggle<CR>", mode = "n",          desc = "Augment chat toggle" },
  },
}

