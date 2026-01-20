return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    main = "ufo",
    init = function()
      local options = vim.opt
      options.foldcolumn = "1"
      options.foldlevel = 99
      options.foldlevelstart = 99
      options.foldenable = true
    end,
    opts = {
      provider_selector = function()
        return ""
      end,
    },
  },
}
