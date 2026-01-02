return {
  -- Maximize/restore split windows
  {
    "szw/vim-maximizer",
    keys = {
      { "<leader>sm", "<cmd>MaximizerToggle<cr>", desc = "Toggle maximize split" },
    },
  },

  -- Auto-resize splits when moving between them
  {
    "nvim-focus/focus.nvim",
    event = "WinEnter",
    opts = {
      enable = true,
      commands = true,
      autoresize = {
        enable = true,
        width = 0,
        height = 0,
        minwidth = 0,
        minheight = 0,
        height_quickfix = 10,
      },
      split = {
        bufnew = false,
        tmux = true, -- Integrate with tmux-navigator
      },
      ui = {
        number = false,
        relativenumber = false,
        hybridnumber = false,
        absolutenumber_unfocussed = false,
        cursorline = true,
        cursorcolumn = false,
        colorcolumn = {
          enable = false,
        },
        signcolumn = true,
        winhighlight = false,
      },
    },
  },

  -- Better window switching
  {
    "https://gitlab.com/yorickpeterse/nvim-window.git",
    keys = {
      { "<leader>sw", "<cmd>lua require('nvim-window').pick()<cr>", desc = "Pick window" },
    },
    config = function()
      require("nvim-window").setup({
        chars = {
          "a", "s", "d", "f", "g", "h", "j", "k", "l",
        },
        normal_hl = "Normal",
        hint_hl = "Bold",
        border = "rounded",
      })
    end,
  },
}
