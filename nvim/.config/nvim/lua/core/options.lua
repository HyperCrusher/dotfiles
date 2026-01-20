local opt = vim.opt
local cmd = vim.cmd

-- Backup / Undo Settings
opt.backup = false
opt.undofile = true
opt.swapfile = false
opt.writebackup = false
opt.hidden = true

-- Search / Command Settings
opt.ignorecase = true
opt.hlsearch = true
opt.cmdheight = 2

-- Wordwrap Settings
opt.wrap = false
opt.breakindent = true
opt.breakindentopt = ""
opt.linebreak = true
opt.breakat = " ^I!@*+;:,./?"
opt.showbreak = "    "
cmd([[set iskeyword+=-]])

-- Indent Settings
opt.autoindent = true
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2

-- Appearance
opt.cursorline = true
cmd([[set cursorlineopt=number]])
opt.termguicolors = true
opt.number = true
opt.relativenumber = true
opt.showmode = false
opt.syntax = "ON"
opt.scrolloff = 8
opt.conceallevel = 0
opt.concealcursor = "n"
opt.foldcolumn = "0"
opt.fillchars = {
    eob = " ",
    horiz = "━",
    horizup = "┻",
    horizdown = "┳",
    vert = "┃",
    vertleft = "┫",
    vertright = "┣",
    verthoriz = "╋",
    foldopen = "",
    foldclose = "",
    fold = " ",
    foldsep = "┃"
}

-- Splitting Settings
opt.splitbelow = true
opt.splitright = true

-- Endocding Settings
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
cmd([[set formatoptions-=c]])
cmd([[set formatoptions-=r]])
cmd([[set formatoptions-=o]])

-- Misc
opt.clipboard = "unnamedplus"
opt.updatetime = 300
opt.timeoutlen = 300
