return {
  {
    "ThePrimeagen/harpoon",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    branch = "harpoon2",
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()
      -- Keybinds when within harpoon
      harpoon:extend({
        UI_CREATE = function(cx)
          local refresh_list = function()
            local len = harpoon:list():length()
            if len > 0 then
              local newList = {}
              for i = 1, len, 1 do
                local item = harpoon:list():get(i)
                if item ~= nil then
                  table.insert(newList, item)
                end
              end
              harpoon:list():clear()
              for _, item in ipairs(newList) do
                harpoon:list():add(item)
              end
            end
          end
          -- Open in vsplit
          vim.keymap.set("n", "<C-v>", function()
            harpoon.ui:select_menu_item({ vsplit = true })
          end, { buffer = cx.bufnr })
          -- Clear
          vim.keymap.set("n", "<C-c>", function()
            harpoon:list():clear()
            harpoon.ui:close_menu()
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end, { buffer = cx.bufnr })
          -- Delete curr idx
          vim.keymap.set("n", "d", function()
            local idx = vim.fn.line(".")
            harpoon:list():remove_at(idx)
            refresh_list()
            harpoon.ui:close_menu()
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end, { buffer = cx.bufnr })
          vim.keymap.set("n", "h", function()
            local idx = vim.fn.line(".")
            print(harpoon:list():get(idx))
          end, { buffer = cx.bufnr })
        end,
      })
    end,
  },
}
