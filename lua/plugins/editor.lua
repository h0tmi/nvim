return {
  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true,
        ts_config = {
          lua = { "string" },
          javascript = { "template_string" },
        },
      })

      -- Integration with nvim-cmp
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- Commenting
  {
    "tpope/vim-commentary",
    event = "VeryLazy",
  },

  -- Surround text objects
  {
    "machakann/vim-sandwich",
    event = "VeryLazy",
  },

  -- Better escape
  {
    "nvim-zh/better-escape.vim",
    event = "InsertEnter",
    init = function()
      vim.g.better_escape_interval = 200
      vim.g.better_escape_shortcut = "jk"
    end,
  },

  -- Undo tree
  {
    "simnalamburt/vim-mundo",
    cmd = { "MundoToggle", "MundoShow" },
    keys = {
      { "<leader>u", "<cmd>MundoToggle<cr>", desc = "Toggle undo tree" },
    },
  },

  -- Tag viewer
  {
    "liuchengxu/vista.vim",
    cmd = "Vista",
    keys = {
      { "<leader>v", "<cmd>Vista!!<cr>", desc = "Toggle Vista" },
    },
    init = function()
      vim.g.vista_default_executive = "nvim_lsp"
      vim.g.vista_fzf_preview = { "right:50%" }
    end,
  },

  -- Async run
  {
    "skywind3000/asyncrun.vim",
    cmd = { "AsyncRun", "AsyncStop" },
    init = function()
      vim.g.asyncrun_open = 8
    end,
  },

  -- English spell checking for comments
  {
    "lucaSartore/fastspell.nvim",
    enabled = true,
    event = "VeryLazy",
    build = "cd jslib && npm install && npm run build",
    config = function()
      require("fastspell").setup({
        -- Only check English spelling in comments and strings
        check_comments = true,
        check_strings = true,
        lang = "en",
        -- Disable naming convention checks
        check_variable_names = false,
        check_function_names = false,
        check_class_names = false,
      })
    end,
  },
}
