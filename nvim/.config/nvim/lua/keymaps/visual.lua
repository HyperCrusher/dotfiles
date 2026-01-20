-- Search for selected text when pressing /
setKeymap("v", "/", '"fy/\\V<C-R>f<CR>N')

-- Preserve selection while indenting
setKeymap("v", ">", ">gv")
setKeymap("v", "<", "<gv")

-- Fold Control
setKeymap("v", "<leader>f", "zf")
setKeymap("n", "<leader>f", "zd")

-- Indent with Tab key
setKeymap("v", "<TAB>", ">gv")
setKeymap("v", "<S-TAB>", "<gv")

-- Paste without overriding clipboard
setKeymap("v", "p", '"_dP')

