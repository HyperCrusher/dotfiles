function setKeymap(mode, keys, action)
  vim.keymap.set(mode, keys, action, { silent = true })
end

function preq(module_name, callback)
  local status, module = pcall(require, module_name)
  if not status then
    return false
  end
  callback(module)
  return true
end

setKeymap("", "<Space>", "<Nop>")

require("keymaps.normal")
require("keymaps.visual")
require("keymaps.plugins")
