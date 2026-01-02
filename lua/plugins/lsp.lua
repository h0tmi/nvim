return {
  -- Mason for LSP server management
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup({
        ui = {
          border = "rounded",
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
    end,
  },

  -- LSP Configuration
  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "hrsh7th/nvim-cmp",
      "carbon-steel/detour.nvim",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "clangd",    -- C++
          "gopls",     -- Go
          "pyright",   -- Python
          "bashls",    -- Bash
        },
        automatic_installation = true,
      })

      -- LSP keymaps on attach
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf, silent = true }

          -- Check if detour is available
          local has_detour, detour = pcall(require, "detour")

          -- Go to definition in detour popup
          vim.keymap.set("n", "gd", function()
            if has_detour then
              detour.Detour()
              vim.lsp.buf.definition()
            else
              vim.lsp.buf.definition()
            end
          end, vim.tbl_extend("force", opts, { desc = "Go to definition" }))

          -- Go to declaration in detour popup
          vim.keymap.set("n", "gD", function()
            if has_detour then
              detour.Detour()
              vim.lsp.buf.declaration()
            else
              vim.lsp.buf.declaration()
            end
          end, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))

          vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Show references" }))
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
          vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Go to type definition" }))
          vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature help" }))
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
          vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Show diagnostics" }))
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
          vim.keymap.set("n", "<leader>f", function()
            vim.lsp.buf.format({ async = true })
          end, vim.tbl_extend("force", opts, { desc = "Format buffer" }))
        end,
      })

      -- Add Mason bin directory to PATH
      local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
      vim.env.PATH = mason_bin .. ":" .. vim.env.PATH

      -- Enhanced capabilities with nvim-cmp
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      if has_cmp then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
      end

      -- Configure diagnostics
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "always",
        },
      })

      -- Diagnostic signs
      local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      -- Setup language servers
      vim.lsp.config("clangd", {
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders=true",
        },
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
        root_markers = { ".clangd", ".clang-tidy", ".clang-format", "compile_commands.json", ".git" },
        capabilities = capabilities,
      })

      vim.lsp.config("gopls", {
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        root_markers = { "go.work", "go.mod", ".git" },
        capabilities = capabilities,
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
            gofumpt = true,
          },
        },
      })

      vim.lsp.config("pyright", {
        cmd = { "pyright-langserver", "--stdio" },
        filetypes = { "python" },
        root_markers = { "pyproject.toml", "setup.py", "requirements.txt", ".git" },
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      })

      vim.lsp.config("bashls", {
        cmd = { "bash-language-server", "start" },
        filetypes = { "sh", "bash" },
        root_markers = { ".git" },
        capabilities = capabilities,
      })

      -- Enable all LSP servers
      vim.lsp.enable({ "clangd", "gopls", "pyright", "bashls" })
    end,
  },
}
