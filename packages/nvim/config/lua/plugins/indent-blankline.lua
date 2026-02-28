return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        indent = { char = "│" },
        scope = { enabled = true },
        exclude = {
            filetypes = { "help", "dashboard", "NvimTree", "lazy", "mason", "toggleterm" },
        },
    },
}

