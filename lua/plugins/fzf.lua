return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find files" },
    { "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "Live grep" },
    { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Find buffers" },
    { "<leader>fh", "<cmd>FzfLua help_tags<cr>", desc = "Help tags" },
    { "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent files" },
    { "<leader>fc", "<cmd>FzfLua grep_cword<cr>", desc = "Find word under cursor" },
    { "<leader>ft", "<cmd>FzfLua tags<cr>", desc = "Tags" },
  },
  config = function()
    require("fzf-lua").setup({
      winopts = {
        height = 0.85,
        width = 0.80,
        border = "rounded",
      },
    })
  end,
}
