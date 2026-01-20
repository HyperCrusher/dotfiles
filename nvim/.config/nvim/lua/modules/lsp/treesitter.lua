local function ensureInstalled()
  return {
    "asm", "bash", "c", "cmake", "comment", "commonlisp", "cpp", "css",
    "dockerfile", "disassembly", "gdscript", "gdshader", "glsl", "go",
    "godot_resource", "gomod", "gosum", "gowork", "gpg", "gitignore", "haskell",
    "hlsl", "html", "http", "hyprlang", "ini", "java", "javascript", "jq", "jsdoc",
    "json5", "kotlin", "latex", "lua", "make", "markdown", "markdown_inline",
    "rust", "scss", "slint", "styled", "tmux", "toml", "tsx", "typescript",
    "typst", "wgsl", "wgsl_bevy", "yaml", "yuck", "zig"
  }
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    init = function(plugin)
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects" },
      { "windwp/nvim-ts-autotag" },
      { "RRethy/nvim-treesitter-endwise" },
      { "m-demare/hlargs.nvim" },
    },
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = ensureInstalled(),
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["as"] = "@scope",
          },
          selection_modes = {
            ["@parameter.outer"] = "v",
            ["@function.outer"] = "V",
            ["@class.outer"] = "V",
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<Leader>sn"] = "@parameter.inner",
          },
          swap_previous = {
            ["<Leader>sp"] = "@parameter.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]c"] = "@class.outer",
            ["]s"] = "@scope",
            ["]z"] = "@fold",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[c"] = "@class.outer",
            ["[s"] = "@scope",
            ["[z"] = "@fold",
          },
          goto_next = {
            ["]]"] = "@conditional.outer",
          },
          goto_previous = {
            ["[["] = "@conditional.outer",
          },
        },
      },
      endwise = {
        enable = true,
      },
      autotag = {
        enable = true,
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
