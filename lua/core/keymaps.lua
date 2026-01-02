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
keymap("n", "<leader>so", ":only<CR>", { desc = "Close all other splits" })
keymap("n", "<leader>sm", ":MaximizerToggle<CR>", { desc = "Toggle maximize split" })

-- Window movement (move splits around)
keymap("n", "<leader>sH", "<C-w>H", { desc = "Move split to far left" })
keymap("n", "<leader>sJ", "<C-w>J", { desc = "Move split to bottom" })
keymap("n", "<leader>sK", "<C-w>K", { desc = "Move split to top" })
keymap("n", "<leader>sL", "<C-w>L", { desc = "Move split to far right" })

-- Window rotation
keymap("n", "<leader>sr", "<C-w>r", { desc = "Rotate splits downward" })
keymap("n", "<leader>sR", "<C-w>R", { desc = "Rotate splits upward" })

-- Split and open file/buffer
keymap("n", "<leader>sf", ":vsplit | lua vim.lsp.buf.definition()<CR>", { desc = "Split and go to definition" })
keymap("n", "<leader>sb", ":vsplit<CR>:Buffers<CR>", { desc = "Split and pick buffer" })

-- C/C++ header/source switching
keymap("n", "<leader>ss", function()
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
end, { desc = "Switch between source/header" })

-- Tab/Shift-Tab for indentation in normal and visual mode
keymap("n", "<Tab>", ">>", { desc = "Indent line" })
keymap("n", "<S-Tab>", "<<", { desc = "Dedent line" })
keymap("v", "<Tab>", ">gv", { desc = "Indent selection" })
keymap("v", "<S-Tab>", "<gv", { desc = "Dedent selection" })

-- Exit visual mode with Esc
keymap("v", "<Esc>", "<Esc>", { desc = "Exit visual mode" })

-- Map q to close windows
keymap("n", "q", "<cmd>close<cr>", { desc = "Close window" })
keymap("n", "Q", "q", { desc = "Record macro (remapped from q)" })

-- Better paste (don't yank replaced text)
keymap("v", "p", '"_dP', { desc = "Paste without yanking" })

-- Move text up and down in visual mode
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move text down" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move text up" })

-- Keep cursor centered when scrolling
keymap("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
keymap("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })

-- Search navigation handled by nvim-hlslens plugin (shows match counts)
-- Press Esc to clear search highlights

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

-- Smart Ctrl+O to close floating windows when jumping back
keymap("n", "<C-o>", function()
  local current_win = vim.api.nvim_get_current_win()
  local current_buf = vim.api.nvim_get_current_buf()
  local config = vim.api.nvim_win_get_config(current_win)

  -- Check if current window is floating
  if config.relative ~= "" then
    -- Get jumplist to see where we're jumping back to
    local jumplist = vim.fn.getjumplist()
    local jumps = jumplist[1]
    local current_idx = jumplist[2]

    -- Check if there's a previous jump
    if current_idx > 0 then
      local prev_jump = jumps[current_idx]

      -- If previous jump is in a different buffer, close popup and jump
      if prev_jump and prev_jump.bufnr ~= current_buf then
        vim.cmd("close")
        vim.schedule(function()
          local key = vim.api.nvim_replace_termcodes("<C-o>", true, false, true)
          vim.api.nvim_feedkeys(key, "n", false)
        end)
        return
      end
    end
  end

  -- Normal jump back behavior (staying in same window)
  local key = vim.api.nvim_replace_termcodes("<C-o>", true, false, true)
  vim.api.nvim_feedkeys(key, "n", false)
end, { desc = "Jump back (close popup if needed)" })
