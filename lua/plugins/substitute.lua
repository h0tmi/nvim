return {
  "gbprod/substitute.nvim",
  event = "VeryLazy",
  config = function()
    local substitute = require("substitute")

    substitute.setup({
      on_substitute = nil,
      yank_substituted_text = false,
      preserve_cursor_position = false,
      modifiers = nil,
      highlight_substituted_text = {
        enabled = true,
        timer = 500,
      },
      range = {
        prefix = "s",
        prompt_current_text = false,
        confirm = false,
        complete_word = false,
        subject = nil,
        range = nil,
        suffix = "",
        auto_apply = false,
        cursor_position = "end",
      },
      exchange = {
        motion = false,
        use_esc_to_cancel = true,
        preserve_cursor_position = false,
      },
    })

    -- Substitute operator
    vim.keymap.set("n", "s", substitute.operator, { noremap = true, desc = "Substitute with motion" })
    vim.keymap.set("n", "ss", substitute.line, { noremap = true, desc = "Substitute line" })
    vim.keymap.set("n", "S", substitute.eol, { noremap = true, desc = "Substitute to end of line" })
    vim.keymap.set("x", "s", substitute.visual, { noremap = true, desc = "Substitute visual" })

    -- Exchange operator
    vim.keymap.set("n", "sx", require("substitute.exchange").operator, { noremap = true, desc = "Exchange with motion" })
    vim.keymap.set("n", "sxx", require("substitute.exchange").line, { noremap = true, desc = "Exchange line" })
    vim.keymap.set("x", "X", require("substitute.exchange").visual, { noremap = true, desc = "Exchange visual" })
    vim.keymap.set("n", "sxc", require("substitute.exchange").cancel, { noremap = true, desc = "Cancel exchange" })
  end,
}
