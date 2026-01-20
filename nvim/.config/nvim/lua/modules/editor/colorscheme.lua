return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    init = function()
      vim.cmd.colorscheme('tokyonight')
    end,
    priority = 1000,
    opts = {
      style = "night",
      transparent = true,
      styles = {
        comments = { italic = false },
        keywords = { italic = false },
        sidebars = "dark",
        floats = "dark",
      }
    },
  },
}
