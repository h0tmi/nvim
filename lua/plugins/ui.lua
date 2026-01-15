return {
  -- File tree
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file tree" },
      { "<leader>tr", "<cmd>NvimTreeFindFile<cr>", desc = "Find file in tree" },
    },
    config = function()
      require("nvim-tree").setup({
        auto_reload_on_write = true,
        disable_netrw = false,
        hijack_netrw = true,
        hijack_cursor = false,
        hijack_unnamed_buffer_when_opening = false,
        open_on_tab = false,
        sort_by = "name",
        update_cwd = false,
        view = {
          width = 30,
          side = "left",
          preserve_window_proportions = false,
          number = false,
          relativenumber = false,
          signcolumn = "yes",
          float = {
            enable = false,
          },
        },
        renderer = {
          indent_markers = {
            enable = false,
            icons = {
              corner = "└ ",
              edge = "│ ",
              none = "  ",
            },
          },
          icons = {
            webdev_colors = true,
          },
        },
        hijack_directories = {
          enable = true,
          auto_open = true,
        },
        update_focused_file = {
          enable = false,
          update_cwd = false,
          ignore_list = {},
        },
        system_open = {
          cmd = "",
          args = {},
        },
        diagnostics = {
          enable = false,
          show_on_dirs = false,
          icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
          },
        },
        filters = {
          dotfiles = false,
          custom = {},
          exclude = {},
        },
        git = {
          enable = true,
          ignore = true,
          timeout = 400,
        },
        actions = {
          use_system_clipboard = true,
          change_dir = {
            enable = true,
            global = false,
            restrict_above_cwd = false,
          },
          open_file = {
            quit_on_open = false,
            resize_window = false,
            window_picker = {
              enable = true,
              chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
              exclude = {
                filetype = { "notify", "qf", "diff", "fugitive", "fugitiveblame" },
                buftype = { "nofile", "terminal", "help" },
              },
            },
          },
        },
        trash = {
          cmd = "trash",
          require_confirm = true,
        },
        log = {
          enable = false,
          truncate = false,
          types = {
            all = false,
            config = false,
            copy_paste = false,
            diagnostics = false,
            git = false,
            profile = false,
          },
        },
        ui = {
          confirm = {
            remove = true,
            trash = true,
            default_yes = false,
          },
        },
      })

      -- Override vim.ui.input for nvim-tree to use floating window
      local original_ui_input = vim.ui.input
      vim.ui.input = function(opts, on_confirm)
        -- Check if this is being called from nvim-tree
        local info = debug.getinfo(2, "S")
        if info and info.source and info.source:match("nvim%-tree") then
          -- Use floating window
          local buf = vim.api.nvim_create_buf(false, true)
          local width = 60
          local height = 1

          -- Get cursor position
          local cursor = vim.api.nvim_win_get_cursor(0)
          local row = cursor[1] - 1
          local col = cursor[2]

          local win = vim.api.nvim_open_win(buf, true, {
            relative = "cursor",
            width = width,
            height = height,
            row = 1,
            col = 0,
            border = "rounded",
            title = " " .. (opts.prompt or "Input") .. " ",
            title_pos = "center",
            style = "minimal",
          })

          -- Set buffer content to default value
          if opts.default then
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, { opts.default })
            vim.api.nvim_win_set_cursor(win, { 1, #opts.default })
            vim.cmd("startinsert!")
          else
            vim.cmd("startinsert")
          end

          -- Return the input when Enter is pressed
          vim.keymap.set({ "i", "n" }, "<CR>", function()
            local result = vim.api.nvim_buf_get_lines(buf, 0, -1, false)[1]
            vim.api.nvim_win_close(win, true)
            vim.api.nvim_buf_delete(buf, { force = true })
            on_confirm(result)
          end, { buffer = buf })

          -- Cancel on Esc
          vim.keymap.set({ "i", "n" }, "<Esc>", function()
            vim.api.nvim_win_close(win, true)
            vim.api.nvim_buf_delete(buf, { force = true })
            on_confirm(nil)
          end, { buffer = buf })
        else
          -- Use default vim.ui.input for other plugins
          original_ui_input(opts, on_confirm)
        end
      end

      -- Fix nvim-tree window width to prevent resizing
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "NvimTree",
        callback = function()
          vim.opt_local.winfixwidth = true
        end,
      })

      -- Ensure tree stays at fixed width when entering/leaving
      vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
        pattern = "*",
        callback = function()
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            local ft = vim.api.nvim_buf_get_option(buf, "filetype")
            if ft == "NvimTree" then
              vim.api.nvim_win_set_width(win, 30)
              vim.wo[win].winfixwidth = true
            end
          end
        end,
      })
    end,
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
      -- Function to get active LSP clients
      local function lsp_clients()
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        if next(clients) == nil then
          return ""
        end

        local client_names = {}
        for _, client in pairs(clients) do
          table.insert(client_names, client.name)
        end

        return " " .. table.concat(client_names, ", ")
      end

      require("lualine").setup({
        options = {
          theme = "gruvbox-material",
          component_separators = { left = "|", right = "|" },
          section_separators = { left = "", right = "" },
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { lsp_clients, "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },

  -- Notifications
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    keys = {
      { "<leader>un", "<cmd>lua require('notify').dismiss({ silent = true, pending = true })<cr>", desc = "Dismiss notifications" },
    },
    config = function()
      local notify = require("notify")

      notify.setup({
        -- Animation style
        stages = "fade_in_slide_out",

        -- Timeout for notifications
        timeout = 3000,

        -- Background color (transparent for gruvbox-material)
        background_colour = "#282828",

        -- Icons
        icons = {
          ERROR = "",
          WARN = "",
          INFO = "",
          DEBUG = "",
          TRACE = "✎",
        },

        -- Max dimensions
        max_width = 50,
        max_height = 10,

        -- Minimum width
        minimum_width = 20,

        -- Position
        top_down = true,

        -- Render style
        render = "compact",

        -- FPS for animations
        fps = 60,
      })

      -- Set as default notify function
      vim.notify = notify

      -- Better error formatting
      vim.notify = function(msg, level, opts)
        -- Filter out LSP progress messages (fidget handles those)
        if type(msg) == "string" and msg:match("^%s*$") then
          return
        end
        notify(msg, level, opts)
      end
    end,
  },

  -- Which-key for keybinding help
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")

      wk.setup({
        win = {
          border = "rounded",
        },
        delay = 1000, -- Delay in ms before which-key popup appears
        icons = {
          separator = "→",
          group = "+ ",
        },
      })

      -- Add group names for better organization
      wk.add({
        { "<leader>b", group = "Buffer" },
        { "<leader>c", group = "Code" },
        { "<leader>d", group = "Diagnostics/Debug" },
        { "<leader>f", group = "Format/Find" },
        { "<leader>q", group = "Quit/Quickfix" },
        { "<leader>r", group = "Rename/Replace" },
        { "<leader>s", group = "Split" },
        { "<leader>t", group = "Tree/Toggle" },
        { "<leader>u", group = "UI" },
        { "<leader>w", group = "Write/Save" },
        { "[", group = "Previous" },
        { "]", group = "Next" },
        { "g", group = "Goto" },
        { "s", group = "Substitute/Exchange" },
      })
    end,
  },

  -- Better quickfix as popup
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    config = function()
      require("bqf").setup({
        auto_resize_height = true,
        preview = {
          auto_preview = false,
          border = "rounded",
          show_title = true,
          win_height = 15,
          win_vheight = 15,
        },
        func_map = {
          open = "<CR>",
          openc = "o",
          drop = "O",
          split = "<C-x>",
          vsplit = "<C-v>",
          tab = "t",
          tabb = "T",
          tabc = "<C-t>",
          ptogglemode = "p",
          pscrollup = "<C-u>",
          pscrolldown = "<C-d>",
          prevfile = "<C-p>",
          nextfile = "<C-n>",
          prevhist = "<",
          nexthist = ">",
          stoggleup = "<S-Tab>",
          stoggledown = "<Tab>",
          stogglevm = "<Tab>",
        },
      })

      -- Make quickfix always float when opened
      vim.api.nvim_create_autocmd("BufWinEnter", {
        pattern = "*",
        callback = function()
          if vim.bo.filetype == "qf" then
            vim.schedule(function()
              local win = vim.api.nvim_get_current_win()
              if not vim.api.nvim_win_is_valid(win) then
                return
              end

              local width = math.floor(vim.o.columns * 0.8)
              local height = math.floor(vim.o.lines * 0.6)
              local row = math.floor((vim.o.lines - height) / 2) - 1
              local col = math.floor((vim.o.columns - width) / 2)

              vim.api.nvim_win_set_config(win, {
                relative = "editor",
                width = width,
                height = height,
                row = row,
                col = col,
                border = "rounded",
                title = " Quickfix ",
                title_pos = "center",
                zindex = 50,
              })
            end)
          end
        end,
      })

      -- Override :copen, :cw, :cwindow to ensure floating behavior
      vim.api.nvim_create_user_command("Copen", "copen", {})
      vim.api.nvim_create_user_command("Cwindow", "cwindow", {})

      -- Remap default commands to use floating version
      vim.keymap.set("n", "<leader>qa", "<cmd>copen<cr>", { desc = "Open quickfix (floating)" })
      vim.keymap.set("n", "<leader>qo", "<cmd>copen<cr>", { desc = "Open quickfix (floating)" })
      vim.keymap.set("n", "<leader>qc", "<cmd>cclose<cr>", { desc = "Close quickfix" })
    end,
  },

  -- Search lens with match counts near cursor
  {
    "kevinhwang91/nvim-hlslens",
    keys = { "/", "?", "*", "#", "n", "N" },
    config = function()
      local hlslens = require("hlslens")

      hlslens.setup({
        calm_down = false, -- Keep highlights visible while navigating
        nearest_only = true, -- Only highlight current match differently
        nearest_float_when = "never",
        auto_enable = true,
      })

      local show_search_count = function()
        -- Get search count
        local info = vim.fn.searchcount({ maxcount = 999 })
        if not info.current or not info.total then
          return
        end

        -- Show count in command line area
        vim.api.nvim_echo({{ string.format("[%d/%d]", info.current, info.total), "IncSearch" }}, false, {})
      end

      local kopts = { noremap = true, silent = true }

      -- Search forward/backward with counts, keep centered
      vim.keymap.set("n", "n", function()
        vim.cmd("normal! " .. vim.v.count1 .. "n")
        vim.cmd("normal! zzzv")
        hlslens.start()
        vim.schedule(show_search_count)
      end, kopts)

      vim.keymap.set("n", "N", function()
        vim.cmd("normal! " .. vim.v.count1 .. "N")
        vim.cmd("normal! zzzv")
        hlslens.start()
        vim.schedule(show_search_count)
      end, kopts)

      vim.keymap.set("n", "*", function()
        vim.cmd("normal! *zzzv")
        hlslens.start()
        vim.schedule(show_search_count)
      end, kopts)

      vim.keymap.set("n", "#", function()
        vim.cmd("normal! #zzzv")
        hlslens.start()
        vim.schedule(show_search_count)
      end, kopts)

      -- Esc to clear search highlights
      vim.keymap.set("n", "<Esc>", function()
        vim.cmd("nohlsearch")
        hlslens.stop()
      end, kopts)

      -- Keep hlslens active when navigating
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        callback = function()
          -- Restart hlslens if search is active
          if vim.v.hlsearch == 1 then
            hlslens.start()
          end
        end,
      })
    end,
  },

  -- Markdown rendering
  {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = true, -- Disabled (requires treesitter)
    ft = "markdown",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    config = function()
      require("render-markdown").setup({})
    end,
  },
}
