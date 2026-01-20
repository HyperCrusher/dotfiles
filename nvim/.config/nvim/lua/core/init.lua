local disable_distribution_plugins = function()
  vim.g.loaded_gzip = 1
  vim.g.loaded_tar = 1
  vim.g.loaded_tarPlugin = 1
  vim.g.loaded_zip = 1
  vim.g.loaded_zipPlugin = 1
  vim.g.loaded_getscript = 1
  vim.g.loaded_getscriptPlugin = 1
  vim.g.loaded_vimball = 1
  vim.g.loaded_vimballPlugin = 1
  vim.g.loaded_matchit = 1
  vim.g.loaded_matchparen = 1
  vim.g.loaded_2html_plugin = 1
  vim.g.loaded_logiPat = 1
  vim.g.loaded_rrhelper = 1
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
  vim.g.loaded_netrwSettings = 1
  vim.g.loaded_netrwFileHandlers = 1
  vim.g.skip_ts_context_commentstring_module = true
end

vim.g.mapleader = " "

local loadPlugins = function()
  require("lazy").setup({
    { import = "modules.editor" },
    { import = "modules.lsp" },
    { import = "modules.tools" },
    { import = "modules.ui" },
  })
end

local init = function()
  disable_distribution_plugins()
  require("core.lazy");
  require("core.options")
  require("core.statusline")
  loadPlugins()
  require("keymaps")
end

init()
