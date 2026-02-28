return {
  "folke/tokyonight.nvim",
  priority = 1000,
  opts = {
    style = "night",
    transparent = false,
    terminal_colors = true,
    on_highlights = function(hl, c)
      -- tokyonight 的 treesitter 组已经很完善，但 @lsp.type.* 没有映射
      -- gopls semantic token 优先级高于 treesitter，必须显式 link 否则退回白色
      hl["@lsp.type.function"]  = { fg = c.blue, bold = true }
      hl["@lsp.type.method"]    = { fg = c.blue }
      hl["@lsp.type.type"]      = { link = "@type" }
      hl["@lsp.type.parameter"] = { link = "@variable.parameter" }
      hl["@lsp.type.variable"]  = {} -- 让 treesitter @variable 接管（tokyonight 默认行为）
    end,
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd.colorscheme("tokyonight")
  end,
}
