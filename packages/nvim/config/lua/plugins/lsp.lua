return {
    "mason-org/mason-lspconfig.nvim",
    opts = {
        ensure_installed = { "pyright", "gopls", "ts_ls" },
    },
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function(_, opts)
        require("mason").setup()
        require("mason-lspconfig").setup(opts)

        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        local on_attach = function(_, bufnr)
            local map = function(keys, func, desc)
                vim.keymap.set("n", keys, func, { buffer = bufnr, silent = true, desc = desc })
            end
            map("gd", vim.lsp.buf.definition, "Go to Definition")
            map("gr", vim.lsp.buf.references, "References")
            map("gI", vim.lsp.buf.implementation, "Go to Implementation")
            map("K", vim.lsp.buf.hover, "Hover Docs")
            map("<leader>rn", vim.lsp.buf.rename, "Rename")
            map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
            map("[d", vim.diagnostic.goto_prev, "Prev Diagnostic")
            map("]d", vim.diagnostic.goto_next, "Next Diagnostic")
        end

        local servers = { "pyright", "gopls", "ts_ls" }
        for _, server in ipairs(servers) do
            vim.lsp.config(server, {
                capabilities = capabilities,
                on_attach = on_attach,
            })
        end
        vim.lsp.enable(servers)
    end,
}
