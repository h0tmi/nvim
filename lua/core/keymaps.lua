local keymap = vim.keymap.set

-- Window navigation handled by vim-tmux-navigator plugin
-- (Ctrl+hjkl works seamlessly between tmux panes and vim windows)

-- Window resizing
keymap("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
keymap("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
keymap("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
keymap("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Window splitting
keymap("n", "<leader>sv", ":vsplit<CR>", { desc = "Split window vertically" })
keymap("n", "<leader>sh", ":split<CR>", { desc = "Split window horizontally" })
keymap("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap("n", "<leader>sx", ":close<CR>", { desc = "Close current split" })

-- Tab/Shift-Tab for indentation in normal and visual mode
keymap("n", "<Tab>", ">>", { desc = "Indent line" })
keymap("n", "<S-Tab>", "<<", { desc = "Dedent line" })
keymap("v", "<Tab>", ">gv", { desc = "Indent selection" })
keymap("v", "<S-Tab>", "<gv", { desc = "Dedent selection" })

-- Exit visual mode with Esc
keymap("v", "<Esc>", "<Esc>", { desc = "Exit visual mode" })

-- Better paste (don't yank replaced text)
keymap("v", "p", '"_dP', { desc = "Paste without yanking" })

-- Move text up and down in visual mode
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move text down" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move text up" })

-- Keep cursor centered when scrolling
keymap("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
keymap("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })

-- Keep search results centered
keymap("n", "n", "nzzzv", { desc = "Next search result centered" })
keymap("n", "N", "Nzzzv", { desc = "Previous search result centered" })

-- Clear search highlight
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Better save and quit
keymap("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
keymap("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
keymap("n", "<leader>Q", "<cmd>qa<CR>", { desc = "Quit all" })

-- Buffer navigation
keymap("n", "[b", ":bprevious<CR>", { desc = "Previous buffer" })
keymap("n", "]b", ":bnext<CR>", { desc = "Next buffer" })
keymap("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })

-- Quickfix navigation
keymap("n", "[q", ":cprevious<CR>", { desc = "Previous quickfix item" })
keymap("n", "]q", ":cnext<CR>", { desc = "Next quickfix item" })
keymap("n", "[Q", ":cfirst<CR>", { desc = "First quickfix item" })
keymap("n", "]Q", ":clast<CR>", { desc = "Last quickfix item" })
keymap("n", "<leader>qo", ":copen<CR>", { desc = "Open quickfix" })
keymap("n", "<leader>qc", ":cclose<CR>", { desc = "Close quickfix" })

-- Location list navigation
keymap("n", "[l", ":lprevious<CR>", { desc = "Previous location item" })
keymap("n", "]l", ":lnext<CR>", { desc = "Next location item" })
keymap("n", "[L", ":lfirst<CR>", { desc = "First location item" })
keymap("n", "]L", ":llast<CR>", { desc = "Last location item" })

-- Insert blank lines without entering insert mode
keymap("n", "<leader>o", "o<Esc>", { desc = "Insert line below" })
keymap("n", "<leader>O", "O<Esc>", { desc = "Insert line above" })

-- Move by display lines
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "Move down by display line" })
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "Move up by display line" })

-- Better line start/end
keymap({ "n", "v" }, "H", "^", { desc = "Go to line start" })
keymap({ "n", "v" }, "L", "g_", { desc = "Go to line end" })
