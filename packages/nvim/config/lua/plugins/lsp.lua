return {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "pyright" }
    },
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
    config = function(_, opts)
      require('mason').setup()

      require("mason-lspconfig").setup(opts)
    end
}
