return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "windwp/nvim-ts-autotag",
      "RRethy/nvim-treesitter-endwise",
      "m-demare/hlargs.nvim",
    },
    config = function()
      local ensureInstalled = {
        "asm", "bash", "c", "cmake", "comment", "commonlisp", "cpp", "css",
        "dockerfile", "disassembly", "gdscript", "gdshader", "glsl", "go",
        "godot_resource", "gomod", "gosum", "gowork", "gpg", "gitignore", "haskell",
        "hlsl", "html", "http", "hyprlang", "ini", "java", "javascript", "jq", "jsdoc",
        "json5", "kotlin", "latex", "lua", "make", "markdown", "markdown_inline",
        "rust", "scss", "slint", "styled", "tmux", "toml", "tsx", "typescript",
        "typst", "wgsl", "wgsl_bevy", "yaml", "yuck", "zig"
      }
      local alreadyInstalled = require("nvim-treesitter.config").get_installed()
      local parsersToInstall = vim.iter(ensureInstalled)
          :filter(function(parser) return not vim.tbl_contains(alreadyInstalled, parser) end)
          :totable()
      require("nvim-treesitter").install(parsersToInstall)

      vim.api.nvim_create_autocmd('FileType', {
        pattern = { '*' },
        callback = function()
          pcall(vim.treesitter.start)
          -- folds
          vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          vim.wo.foldmethod = 'expr'
          -- indents
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    init = function()
      vim.g.no_plugin_maps = true
    end,
    config = true,
  }
}
