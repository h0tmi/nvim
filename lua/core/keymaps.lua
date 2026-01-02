local keymap = vim.keymap
local uv = vim.uv

-- ============================================================================
-- GENERAL MAPPINGS
-- ============================================================================

-- Save key strokes (now we do not need to press shift to enter command mode)
keymap.set({ "n", "x" }, ";", ":")

-- ============================================================================
-- INSERT MODE MAPPINGS
-- ============================================================================

-- Turn the word under cursor to upper case
keymap.set("i", "<c-u>", "<Esc>viwUea")

-- Turn the current word into title case
keymap.set("i", "<c-t>", "<Esc>b~lea")

-- Go to the beginning and end of current line in insert mode quickly
keymap.set("i", "<C-A>", "<HOME>")
keymap.set("i", "<C-E>", "<END>")

-- Delete the character to the right of the cursor
keymap.set("i", "<C-D>", "<DEL>")

-- Insert semicolon in the end
keymap.set("i", "<A-;>", "<Esc>miA;<Esc>`ii")

-- Break inserted text into smaller undo units when we insert some punctuation chars
local undo_ch = { ",", ".", "!", "?", ";", ":" }
for _, ch in ipairs(undo_ch) do
  keymap.set("i", ch, ch .. "<c-g>u")
end

-- ============================================================================
-- COMMAND MODE MAPPINGS
-- ============================================================================

-- Go to beginning of command in command-line mode
keymap.set("c", "<C-A>", "<HOME>")

-- ============================================================================
-- NORMAL MODE MAPPINGS
-- ============================================================================

-- Paste non-linewise text above or below current line
keymap.set("n", "<leader>p", "m`o<ESC>p``", { desc = "paste below current line" })
keymap.set("n", "<leader>P", "m`O<ESC>p``", { desc = "paste above current line" })

-- Shortcut for faster save and quit
keymap.set("n", "<leader>w", "<cmd>update<cr>", { silent = true, desc = "save buffer" })

-- Saves the file if modified and quit
keymap.set("n", "<leader>q", "<cmd>x<cr>", { silent = true, desc = "quit current window" })

-- Quit all opened buffers
keymap.set("n", "<leader>Q", "<cmd>qa!<cr>", { silent = true, desc = "quit nvim" })

-- Navigation in the location and quickfix list
keymap.set("n", "[l", "<cmd>lprevious<cr>zv", { silent = true, desc = "previous location item" })
keymap.set("n", "]l", "<cmd>lnext<cr>zv", { silent = true, desc = "next location item" })

keymap.set("n", "[L", "<cmd>lfirst<cr>zv", { silent = true, desc = "first location item" })
keymap.set("n", "]L", "<cmd>llast<cr>zv", { silent = true, desc = "last location item" })

keymap.set("n", "[q", "<cmd>cprevious<cr>zv", { silent = true, desc = "previous qf item" })
keymap.set("n", "]q", "<cmd>cnext<cr>zv", { silent = true, desc = "next qf item" })

keymap.set("n", "[Q", "<cmd>cfirst<cr>zv", { silent = true, desc = "first qf item" })
keymap.set("n", "]Q", "<cmd>clast<cr>zv", { silent = true, desc = "last qf item" })

-- Close location list or quickfix list if they are present
keymap.set("n", [[\x]], "<cmd>windo lclose <bar> cclose <cr>", {
  silent = true,
  desc = "close qf and location list",
})

-- Delete a buffer, without closing the window
keymap.set("n", [[\d]], "<cmd>bprevious <bar> bdelete #<cr>", {
  silent = true,
  desc = "delete buffer",
})

-- Insert a blank line below or above current line (do not move the cursor)
keymap.set("n", "<space>o", "printf('m`%so<ESC>``', v:count1)", {
  expr = true,
  desc = "insert line below",
})

keymap.set("n", "<space>O", "printf('m`%sO<ESC>``', v:count1)", {
  expr = true,
  desc = "insert line above",
})

-- Move the cursor based on physical lines, not the actual lines
keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
keymap.set("n", "^", "g^")
keymap.set("n", "0", "g0")

-- Go to start or end of line easier
keymap.set({ "n", "x" }, "H", "^")
keymap.set({ "n", "x" }, "L", "g_")

-- Edit and reload nvim config file quickly
keymap.set("n", "<leader>ev", "<cmd>tabnew $MYVIMRC <bar> tcd %:h<cr>", {
  silent = true,
  desc = "open init.lua",
})

keymap.set("n", "<leader>sv", function()
  vim.cmd([[
      update $MYVIMRC
      source $MYVIMRC
    ]])
  vim.notify("Nvim config successfully reloaded!", vim.log.levels.INFO, { title = "nvim-config" })
end, {
  silent = true,
  desc = "reload init.lua",
})

-- Reselect the text that has just been pasted
keymap.set("n", "<leader>v", "printf('`[%s`]', getregtype()[0])", {
  expr = true,
  desc = "reselect last pasted area",
})

-- Always use very magic mode for searching
keymap.set("n", "/", [[/\v]])

-- Change current working directory locally and print cwd after that
keymap.set("n", "<leader>cd", "<cmd>lcd %:p:h<cr><cmd>pwd<cr>", { desc = "change cwd" })

-- Toggle spell checking
keymap.set("n", "<F11>", "<cmd>set spell!<cr>", { desc = "toggle spell" })
keymap.set("i", "<F11>", "<c-o><cmd>set spell!<cr>", { desc = "toggle spell" })

-- Change text without putting it into the vim register
keymap.set("n", "c", '"_c')
keymap.set("n", "C", '"_C')
keymap.set("n", "cc", '"_cc')
keymap.set("x", "c", '"_c')

-- Copy entire buffer
keymap.set("n", "<leader>y", "<cmd>%yank<cr>", { desc = "yank entire buffer" })

-- Switch windows
keymap.set("n", "<left>", "<c-w>h")
keymap.set("n", "<Right>", "<C-W>l")
keymap.set("n", "<Up>", "<C-W>k")
keymap.set("n", "<Down>", "<C-W>j")

-- Do not move my cursor when joining lines
keymap.set("n", "J", function()
  vim.cmd([[
      normal! mzJ`z
      delmarks z
    ]])
end, {
  desc = "join lines without moving cursor",
})

keymap.set("n", "gJ", function()
  vim.cmd([[
      normal! mzgJ`z
      delmarks z
    ]])
end, {
  desc = "join lines without moving cursor",
})

-- Blink cursor to show position
keymap.set("n", "<leader>cb", function()
  local cnt = 0
  local blink_times = 7
  local timer = uv.new_timer()
  if timer == nil then
    return
  end

  timer:start(0, 100, vim.schedule_wrap(function()
    vim.cmd [[
      set cursorcolumn!
      set cursorline!
    ]]

    if cnt == blink_times then
      timer:close()
    end

    cnt = cnt + 1
  end)
  )
end, { desc = "show cursor" })

-- Keep cursor centered when scrolling
keymap.set("n", "<C-d>", "<C-d>zz", { desc = "scroll down and center" })
keymap.set("n", "<C-u>", "<C-u>zz", { desc = "scroll up and center" })

-- Buffer navigation
keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "previous buffer" })
keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "next buffer" })

-- ============================================================================
-- VISUAL/VISUAL-LINE MODE MAPPINGS
-- ============================================================================

-- Do not include white space characters when using $ in visual mode
keymap.set("x", "$", "g_")

-- Continuous visual shifting (does not exit Visual mode)
keymap.set("x", "<", "<gv")
keymap.set("x", ">", ">gv")

-- Tab/Shift+Tab for indentation in visual mode
keymap.set("x", "<Tab>", ">gv", { desc = "indent selection" })
keymap.set("x", "<S-Tab>", "<gv", { desc = "dedent selection" })

-- Replace visual selection with text in register, but not contaminate the register
keymap.set("x", "p", '"_c<Esc>p')

-- Move text up and down in visual mode
keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "move text down" })
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "move text up" })

-- ============================================================================
-- TERMINAL MODE MAPPINGS
-- ============================================================================

-- Use Esc to quit builtin terminal
keymap.set("t", "<Esc>", [[<c-\><c-n>]])

-- ============================================================================
-- WINDOW MANAGEMENT
-- ============================================================================

-- Window resizing
keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "increase window height" })
keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "decrease window height" })
keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "decrease window width" })
keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "increase window width" })

-- Window splitting
keymap.set("n", "<leader>sh", ":split<CR>", { desc = "split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "make splits equal size" })
keymap.set("n", "<leader>sx", ":close<CR>", { desc = "close current split" })
keymap.set("n", "<leader>so", ":only<CR>", { desc = "close all other splits" })

-- Window movement (move splits around)
keymap.set("n", "<leader>sH", "<C-w>H", { desc = "move split to far left" })
keymap.set("n", "<leader>sJ", "<C-w>J", { desc = "move split to bottom" })
keymap.set("n", "<leader>sK", "<C-w>K", { desc = "move split to top" })
keymap.set("n", "<leader>sL", "<C-w>L", { desc = "move split to far right" })

-- Window rotation
keymap.set("n", "<leader>sr", "<C-w>r", { desc = "rotate splits downward" })
keymap.set("n", "<leader>sR", "<C-w>R", { desc = "rotate splits upward" })

-- ============================================================================
-- C/C++ SPECIFIC
-- ============================================================================

-- C/C++ header/source switching
keymap.set("n", "<leader>ss", function()
  local ext = vim.fn.expand("%:e")
  local base = vim.fn.expand("%:r")
  local target = ""

  -- Source extensions -> Header
  if ext == "cpp" or ext == "cc" or ext == "c" or ext == "cxx" then
    for _, header_ext in ipairs({ "h", "hpp", "hxx" }) do
      local candidate = base .. "." .. header_ext
      if vim.fn.filereadable(candidate) == 1 then
        target = candidate
        break
      end
    end
  -- Header extensions -> Source
  elseif ext == "h" or ext == "hpp" or ext == "hxx" then
    for _, source_ext in ipairs({ "cpp", "cc", "c", "cxx" }) do
      local candidate = base .. "." .. source_ext
      if vim.fn.filereadable(candidate) == 1 then
        target = candidate
        break
      end
    end
  end

  if target ~= "" then
    vim.cmd("edit " .. target)
  else
    vim.notify("No corresponding header/source file found", vim.log.levels.WARN)
  end
end, { desc = "switch between source/header" })

-- ============================================================================
-- FILE EXPLORER
-- ============================================================================

-- Toggle nvim-tree
keymap.set("n", "<space>e", function()
  require("nvim-tree.api").tree.toggle()
end, {
  silent = true,
  desc = "toggle nvim-tree",
})
