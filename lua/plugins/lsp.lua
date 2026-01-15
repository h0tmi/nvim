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

          -- Go to definition
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))

          -- Go to declaration
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))

          vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Show references" }))
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
          vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Go to type definition" }))
          vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature help" }))

          -- Floating rename near cursor
          vim.keymap.set("n", "<leader>rn", function()
            local curr_name = vim.fn.expand("<cword>")
            local params = vim.lsp.util.make_position_params()

            -- Override vim.ui.input to show floating window near cursor
            local original_input = vim.ui.input
            vim.ui.input = function(input_opts, on_confirm)
              local buf = vim.api.nvim_create_buf(false, true)
              local width = math.max(40, #curr_name + 10)

              -- Open window relative to cursor
              local win = vim.api.nvim_open_win(buf, true, {
                relative = "cursor",
                row = 1,
                col = 0,
                width = width,
                height = 1,
                style = "minimal",
                border = "rounded",
                title = " Rename ",
                title_pos = "center",
              })

              -- Set initial value
              vim.api.nvim_buf_set_lines(buf, 0, -1, false, { input_opts.default or "" })
              vim.cmd("startinsert!")

              -- Setup keymaps
              vim.keymap.set("i", "<CR>", function()
                local new_name = vim.api.nvim_buf_get_lines(buf, 0, -1, false)[1]
                vim.api.nvim_win_close(win, true)
                vim.ui.input = original_input -- Restore
                if on_confirm then
                  on_confirm(new_name)
                end
              end, { buffer = buf })

              vim.keymap.set("i", "<Esc>", function()
                vim.api.nvim_win_close(win, true)
                vim.ui.input = original_input -- Restore
                if on_confirm then
                  on_confirm(nil)
                end
              end, { buffer = buf })
            end

            vim.lsp.buf.rename()
          end, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))

          -- Code actions in popup window
          vim.keymap.set("n", "<leader>ca", function()
            local original_select = vim.ui.select
            vim.ui.select = function(items, select_opts, on_choice)
              if #items == 0 then
                vim.notify("No code actions available", vim.log.levels.INFO)
                vim.ui.select = original_select
                return
              end

              local buf = vim.api.nvim_create_buf(false, true)
              local lines = {}
              for i, item in ipairs(items) do
                local title
                if select_opts.format_item then
                  title = select_opts.format_item(item)
                elseif type(item) == "table" and item.title then
                  title = item.title
                else
                  title = tostring(item)
                end
                table.insert(lines, string.format("%d: %s", i, title))
              end

              local width = 60
              for _, line in ipairs(lines) do
                width = math.max(width, #line + 4)
              end
              local height = math.min(#lines, 15)

              vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
              vim.api.nvim_set_option_value("modifiable", false, { buf = buf })

              local win = vim.api.nvim_open_win(buf, true, {
                relative = "cursor",
                row = 1,
                col = 0,
                width = width,
                height = height,
                style = "minimal",
                border = "rounded",
                title = " Code Actions ",
                title_pos = "center",
              })

              local function close_and_restore()
                if vim.api.nvim_win_is_valid(win) then
                  vim.api.nvim_win_close(win, true)
                end
                vim.ui.select = original_select
              end

              -- Select action with number key or Enter
              for i = 1, math.min(#items, 9) do
                vim.keymap.set("n", tostring(i), function()
                  close_and_restore()
                  if on_choice then on_choice(items[i], i) end
                end, { buffer = buf })
              end

              vim.keymap.set("n", "<CR>", function()
                local lnum = vim.api.nvim_win_get_cursor(win)[1]
                close_and_restore()
                if on_choice then on_choice(items[lnum], lnum) end
              end, { buffer = buf })

              vim.keymap.set("n", "<Esc>", function()
                close_and_restore()
                if on_choice then on_choice(nil, nil) end
              end, { buffer = buf })

              vim.keymap.set("n", "q", function()
                close_and_restore()
                if on_choice then on_choice(nil, nil) end
              end, { buffer = buf })

              -- Navigate with j/k
              vim.keymap.set("n", "j", "j", { buffer = buf })
              vim.keymap.set("n", "k", "k", { buffer = buf })
            end

            vim.lsp.buf.code_action()
          end, vim.tbl_extend("force", opts, { desc = "Code action" }))
          vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Show diagnostics" }))
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
          -- Format is handled by conform.nvim (,f keybinding)
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
        root_markers = { ".clangd", ".clang-tidy", ".git", "compile_commands.json" },
      })

      -- Configure LSP floating window borders (like old config)
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
      })

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
      })

      -- Configure diagnostic floating windows
      vim.diagnostic.config({
        float = {
          border = "rounded",
          source = "always",
        },
      })
    end,
  },
}
