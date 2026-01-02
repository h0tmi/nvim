return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = { "n", "v" },
      desc = "Format buffer",
    },
  },
  opts = {
    formatters_by_ft = {
      -- C/C++
      c = { "clang_format" },
      cpp = { "clang_format" },

      -- Python
      python = { "black", "isort" },

      -- Go
      go = { "gofumpt", "goimports" },

      -- Shell/Bash
      sh = { "shfmt" },
      bash = { "shfmt" },

      -- Web
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      css = { "prettier" },
      html = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },

      -- Lua
      lua = { "stylua" },

      -- Rust
      rust = { "rustfmt" },

      -- Use LSP for everything else
      ["*"] = { "lsp_fallback" },
    },

    format_on_save = {
      -- These options will be passed to conform.format()
      timeout_ms = 500,
      lsp_fallback = true,
    },

    formatters = {
      clang_format = {
        prepend_args = { "--style=file" }, -- Use .clang-format file if exists
      },
      shfmt = {
        prepend_args = { "-i", "4" }, -- 4 space indent for shell scripts
      },
    },
  },
  init = function()
    -- If you want to enable format on save, you can use this:
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

    -- Add command to toggle format on save
    vim.api.nvim_create_user_command("FormatToggle", function()
      vim.g.disable_autoformat = not vim.g.disable_autoformat
      if vim.g.disable_autoformat then
        vim.notify("Format on save: disabled", vim.log.levels.INFO)
      else
        vim.notify("Format on save: enabled", vim.log.levels.INFO)
      end
    end, { desc = "Toggle format on save" })

    -- Disable format on save conditionally
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*",
      callback = function(args)
        if vim.g.disable_autoformat then
          return
        end
        require("conform").format({ bufnr = args.buf, lsp_fallback = true })
      end,
    })
  end,
}
