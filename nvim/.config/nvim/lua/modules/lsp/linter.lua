return {
  {
    "mfussenegger/nvim-lint",
    config = function()
      require("lint").linters_by_ft = {
        sh = {"shellcheck"},
        c = {"clangtidy", "cppcheck", "cpplint"},
        css = {"stylelint"},
        docker = {"dockerlint"},
        java = {"checkstyle"},
        --javascript = {"xo"}, -- Write a wrapper for xo
        json = {"jsonlint"},
        markdown = {"markdownlint"},
        typescript = {"xo"}, 
        yaml = {"yamllint"},
      }
    end,
  }
}
