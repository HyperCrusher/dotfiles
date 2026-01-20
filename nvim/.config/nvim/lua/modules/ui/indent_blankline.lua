return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = {
        smart_indent_cap = true,
      },
      scope = {
        show_start = false,
        include = {
          node_type = { lua = { "return_statement", "table_constructor" } },
        }
      }
    }
  },
}
