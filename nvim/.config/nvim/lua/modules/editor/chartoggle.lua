return {
  {
    "saifulapm/commasemi.nvim",
    lazy = false,
    init = function()
      vim.g.commasemi_disable_commands = true
    end,
    opts = {
      leader = "<leader>",
      keymaps = true,
      commands = false
    }
  }
}
