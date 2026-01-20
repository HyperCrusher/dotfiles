-- Telescope
setKeymap("n", "<leader><leader>", ":Yazi<cr>")
setKeymap("n", "<leader>ff", ":Telescope find_files<cr>")
setKeymap("n", "<leader>f", ":Telescope buffers<cr>")
setKeymap("n", "<leader>s", ":Telescope live_grep<cr>")

-- Toggle Folds
preq("fold-cycle", function(fold) setKeymap("n", "<tab>", fold.open) end)

-- Toggle Term
preq("toggleterm.terminal", function(mod)
  local Terminal = mod.Terminal

  local TermOpts = {
    direction = "horizontal",
    hidden = true,
    auto_scroll = true,
    close_on_exit = false,
    on_open = function(term)
      local opts = { buffer = term.bufnr, silent = true }
      vim.keymap.set('t', '<leader>o', function() term:toggle() end, opts)
    end
  }
  local function create_term(id)
    return Terminal:new(vim.tbl_deep_extend("force", TermOpts, { id = id }))
  end

  local runner   = create_term(10)
  local compiler = create_term(11)
  local user     = create_term(12)

  local function term_send(term, cmd, cancel, ignore_focus)
    if not term:is_open() then term:open() end
    vim.defer_fn(function()
      if cancel then term:send("\x03\x03", ignore_focus) end
      if cmd then term:send(cmd, ignore_focus) end
    end, 300)
  end

  local function smart_toggle()
    local targets = { runner, compiler, user }
    local any_open = false
    for _, term in ipairs(targets) do
      if term:is_open() then
        term:close()
        any_open = true
      end
    end
    if not any_open then
      user:open()
    end
  end

  setKeymap("n", "<leader>o", smart_toggle)
  setKeymap("n", "<leader>cc", function() term_send(compiler, "cargo build") end)
  setKeymap("n", "<leader>rr", function() term_send(runner, "cargo run", true, true) end)
  setKeymap("n", "<leader>vv", function() if not runner:is_open() then runner:open() end end)
end)

-- Harpoon
preq("harpoon", function(harpoon)
  setKeymap("n", "<leader>h",
    function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
  setKeymap("n", "<leader>ha", function() harpoon:list():add() end)
  setKeymap("n", "<leader>hf", function() harpoon:list():next({ ui_nav_wrap = true }) end)
  setKeymap("n", "<leader>hp", function() harpoon:list():prev({ ui_nav_wrap = true }) end)
end)

-- moveline
preq("moveline", function(moveline)
  setKeymap("v", "<C-k>", moveline.block_up)
  setKeymap("v", "<C-j>", moveline.block_down)
end)
-- Trouble
setKeymap("n", "<leader>t", ":Trouble diagnostics toggle<cr>")

-- Lazygit
setKeymap("n", "<leader>g", ":LazyGit<cr>")
