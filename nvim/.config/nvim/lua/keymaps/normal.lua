-- Alt + movement for window resizing
setKeymap("n", "<M-k>", ":resize -2<CR>")
setKeymap("n", "<M-j>", ":resize +2<CR>")
setKeymap("n", "<M-l>", ":vertical resize +2<CR>")
setKeymap("n", "<M-h>", ":vertical resize -2<CR>")

-- Ctrl + Movement for window navigation
setKeymap("n", "<C-k>", ":NvimTmuxNavigateUp<CR>")
setKeymap("n", "<C-j>", ":NvimTmuxNavigateDown<CR>")
setKeymap("n", "<C-l>", ":NvimTmuxNavigateRight<CR>")
setKeymap("n", "<C-h>", ":NvimTmuxNavigateLeft<CR>")

-- Close the current window
setKeymap("n", "<Leader>c", ":close<CR>")

-- Ctrl + S to save
setKeymap("n", "<C-s>", ":w<CR>")

-- Center the screen on movement
setKeymap("n", "j", "jzz")
setKeymap("n", "k", "kzz")
setKeymap("n", "n", "nzz")
setKeymap("n", "N", "Nzz")
setKeymap("n", "<C-o>", "<C-o>zz")
setKeymap("n", "<C-i>", "<C-i>zz")

-- Copy Whole Doc
setKeymap("n", "<leader>ya", "ggVGy<C-o>")

-- Replace whole doc
setKeymap("n", "<leader>ra", "ggVGpgg")

-- Make a select to end
setKeymap("n", "<leader>L", "vg_")

-- Move to start of line
setKeymap("n", "<BS>", "^")

-- Move to end of line
setKeymap("n", "L", "$")

-- Toggle lsp inlay hints (like rust type annotations)
setKeymap("n", "<leader>n", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end)

-- Make file executable
setKeymap("n", "<leader>cx", ":!chmod +x %<cr>")

setKeymap("n", "<leader>cp", ":let @+ = expand('%:p')<cr>")
