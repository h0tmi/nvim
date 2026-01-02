return {
  "carbon-steel/detour.nvim",
  event = "VeryLazy",
  keys = {
    { "<leader>dt", "<cmd>lua require('detour').Detour()<cr>", desc = "Open detour popup" },
    { "<leader>dp", "<cmd>lua require('detour').DetourCurrentWindow()<cr>", desc = "Detour current window" },
  },
  config = function()
    require("detour").setup()
  end,
}
