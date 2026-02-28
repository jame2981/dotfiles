return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
        { "<leader>cf", function() require("conform").format({ async = true, lsp_fallback = true }) end, desc = "Format File" },
    },
    opts = {
        formatters_by_ft = {
            lua        = { "stylua" },
            python     = { "isort", "black" },
            go         = { "goimports", "gofmt" },
            typescript = { "prettier" },
            javascript = { "prettier" },
            json       = { "prettier" },
            yaml       = { "prettier" },
            markdown   = { "prettier" },
        },
        format_on_save = {
            timeout_ms = 500,
            lsp_fallback = true,
        },
    },
}

