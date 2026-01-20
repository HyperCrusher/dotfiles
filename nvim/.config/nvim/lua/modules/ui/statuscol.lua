return {
  {
    "luukvbaal/statuscol.nvim",
    dependencies = { "lewis6991/gitsigns.nvim", "mfussenegger/nvim-dap" },
    config = function()
      local builtin = require("statuscol.builtin")
      require("statuscol").setup({
        ft_ignore = { "NvimTree", "toggleterm", "help", "quickfix", "preview" },
        segments = {
          { sign = { namespace = { "gitsign*" } }, click = "v:lua.ScSa" },
          { sign = { name = { ".*" } } },
          { text = { builtin.lnumfunc, " " }, condition = { true, builtin.not_empty }, click = "v:lua.ScLa" },
          { text = { builtin.foldfunc, "  " }, click = "v:lua.ScFa" },
        },
      })
    end,
  },
}
