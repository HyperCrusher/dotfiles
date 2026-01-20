return {
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = function()
      local apair = require("nvim-autopairs")
      local Rule = require("nvim-autopairs.rule")
      apair.setup({})
      -- Custom function to check if we're at the top level
      local function is_top_level()
        local line = vim.fn.line('.')
        local col = vim.fn.col('.')
        return vim.fn.indent(line) == 0
      end

      -- Custom rule for Nix files ({} at top {}; when not)
      apair.add_rules({
        Rule('{', '}', 'nix')
            :with_pair(function(opts)
              if is_top_level() then
                return true
              else
                vim.api.nvim_input('};<Left><Left>')
                return false
              end
            end)
            :with_move(function(opts)
              return opts.char == '}'
            end)
            :with_cr(function(opts)
              return true
            end)
      })
    end
  }
}
