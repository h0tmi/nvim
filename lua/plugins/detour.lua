return {
  "carbon-steel/detour.nvim",
  event = "VeryLazy",
  keys = {
    { "<leader>dt", "<cmd>lua require('detour').Detour()<cr>", desc = "Open detour popup" },
    { "<leader>dp", "<cmd>lua require('detour').DetourCurrentWindow()<cr>", desc = "Detour current window" },
  },
  config = function()
    require("detour").setup()

    -- Auto-configure detour popups
    vim.api.nvim_create_autocmd("WinEnter", {
      callback = function()
        local win = vim.api.nvim_get_current_win()
        local config = vim.api.nvim_win_get_config(win)

        -- Check if this is a floating window (detour popup)
        if config.relative ~= "" then
          -- Match the theme colors
          vim.api.nvim_set_option_value("winhighlight", "NormalFloat:Normal,FloatBorder:Normal", { win = win })
          vim.wo[win].winblend = 0
        end
      end,
    })
  end,
}
