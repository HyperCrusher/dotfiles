-- StatusLine Functions / Autocmds
-- Word Count for notes / text
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "TextChanged", "TextChangedI" }, {
  desc = "word count for the statusline",
  pattern = { "*.md", "*.txt" },
  callback = function()
    local wc = vim.fn.wordcount().words
    if wc == 1 then
      vim.b.wordcount = wc .. " word"
    else
      vim.b.wordcount = wc .. " words"
    end
  end,
  group = init_group,
})

-- Git and LSP info
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "FocusGained" }, {
  desc = "git branch and LSP errors for the statusline",
  callback = function()
    local branch = vim.fn.system("git branch --show-current | tr -d '\n'")
    if string.sub(branch, 1, 16) == "fatal: not a git" then
      vim.b.branch_name = ""
    else
      vim.b.branch_name = "  " .. branch .. " "
    end
    local num_errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    vim.b.errors = (num_errors > 0) and ("  " .. num_errors .. " ") or ""

    local num_warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    vim.b.warnings = (num_warnings > 0) and ("   " .. num_warnings .. " ") or ""
  end,
  group = init_group,
})

-- Status line setup
local function status_line()
  local file_name = "%#Directory#%f%#LineNr#"
  local file_type = "%#ModeMsg#%y%#LineNr#"
  local right_align = "%="
  local spacer = "  "
  local gitbranch = '%#Todo# %{get(b:, "branch_name", "")}  %#LineNr#'
  local lsp_errors = '%#DiagnosticError#%{get(b:, "errors", "")}%#LineNr#'
  local lsp_warnings = '%#WarningMsg#%{get(b:, "warnings", "")}%#LineNr#'
  local current_time = '%#DiffText#%{strftime(" %I:%M ")}'
  local word_count = '%#LineNr#%{get(b:, "wordcount", "")}'

  return table.concat({
    gitbranch,
    spacer,
    file_name,
    spacer,
    lsp_errors,
    lsp_warnings,
    spacer,
    right_align,
    file_type,
    spacer,
    word_count,
    spacer,
    current_time,
  })
end

-- Update statusline every second for clock
vim.cmd([[call timer_start(1000, {-> execute(':let &stl=&stl')}, {'repeat': -1})]])

vim.opt.laststatus = 3
vim.opt.statusline = status_line()
