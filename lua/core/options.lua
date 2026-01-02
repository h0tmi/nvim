local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Tabs and indentation
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true

-- Line wrapping
opt.wrap = false
opt.linebreak = true
opt.showbreak = "↪"

-- Search settings
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true  -- Keep search highlighted
opt.incsearch = true -- Show matches while typing

-- Appearance
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Behavior
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.confirm = true -- Ask for confirmation when handling unsaved or read-only files
opt.splitright = true
opt.splitbelow = true
opt.splitkeep = "screen"
opt.winminwidth = 5
opt.winminheight = 1
opt.equalalways = false -- Don't auto-resize all windows when closing one

-- Files
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undo"

-- Completion
opt.completeopt = "menu,menuone,noselect"
opt.pumheight = 10

-- Timing
opt.updatetime = 250
opt.timeoutlen = 500

-- Encoding
opt.fileencoding = "utf-8"
opt.encoding = "utf-8"

-- Other
opt.showmode = false
opt.showcmd = false
opt.laststatus = 3
opt.fillchars = {
  fold = " ",
  foldsep = " ",
  foldopen = "v",
  foldclose = ">",
  vert = "│",
  eob = " ",
  msgsep = "‾",
  diff = "╱",
}

-- Folding
opt.foldcolumn = "0"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true

-- Wild menu
opt.wildmode = "longest:full,full"
opt.wildignore = {
  "*.o", "*.obj", "*.dylib", "*.bin", "*.dll", "*.exe",
  "*/.git/*", "*/.svn/*", "*/__pycache__/*", "*/build/**",
  "*.jpg", "*.png", "*.jpeg", "*.bmp", "*.gif", "*.tiff", "*.svg", "*.ico",
  "*.pyc", "*.pkl",
  "*.DS_Store",
  "*.aux", "*.bbl", "*.blg", "*.brf", "*.fls", "*.fdb_latexmk", "*.synctex.gz",
}
