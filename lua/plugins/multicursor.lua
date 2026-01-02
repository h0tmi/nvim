return {
  "jake-stewart/multicursor.nvim",
  branch = "1.0",
  event = "VeryLazy",
  config = function()
    local mc = require("multicursor-nvim")

    mc.setup()

    local set = vim.keymap.set

    -- Add or skip cursor above/below the main cursor
    set({ "n", "v" }, "<C-Up>", function() mc.lineAddCursor(-1) end)
    set({ "n", "v" }, "<C-Down>", function() mc.lineAddCursor(1) end)
    set({ "n", "v" }, "<C-n>", function() mc.matchAddCursor(1) end)
    set({ "n", "v" }, "<C-s>", function() mc.matchSkipCursor(1) end)

    -- Add all matches
    set({ "n", "v" }, "<leader>A", mc.matchAllAddCursors)

    -- Rotate main cursor
    set({ "n", "v" }, "<C-Left>", mc.nextCursor)
    set({ "n", "v" }, "<C-Right>", mc.prevCursor)

    -- Delete cursor
    set({ "n", "v" }, "<leader>x", mc.deleteCursor)

    -- Easy way to add and remove cursors
    set("n", "<C-LeftMouse>", mc.handleMouse)

    -- Clear cursors
    set({ "n", "v" }, "<esc>", function()
      if not mc.cursorsEnabled() then
        mc.enableCursors()
      elseif mc.hasCursors() then
        mc.clearCursors()
      else
        -- Default <esc> behavior
      end
    end)

    -- Customize how cursors look
    vim.api.nvim_set_hl(0, "MultiCursorCursor", { link = "Cursor" })
    vim.api.nvim_set_hl(0, "MultiCursorVisual", { link = "Visual" })
    vim.api.nvim_set_hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
    vim.api.nvim_set_hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
  end,
}
