return {
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {
      keymaps = {
        normal = "S",
        normal_cur = "Ss",
        visual = "S",
        delete = "ds",
        change = "cs",
      },
    },
  }
}
