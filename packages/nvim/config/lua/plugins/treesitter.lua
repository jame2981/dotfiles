-- nvim-treesitter v1.0: 不再自动启动 highlight，需手动在 FileType 时调用
return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.install").install({
      "bash", "c", "diff", "go", "html", "javascript", "jsdoc",
      "json", "lua", "luadoc", "luap", "markdown",
      "markdown_inline", "printf", "python", "query", "regex",
      "toml", "tsx", "typescript", "vim", "vimdoc", "xml", "yaml",
    })
    -- nvim 0.11 不会自动为第三方 parser 启动 treesitter highlight
    -- pcall 忽略无 parser 的 filetype
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        pcall(vim.treesitter.start, args.buf)
      end,
    })
  end,
}

