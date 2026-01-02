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
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
          icons = {
            show = {
              git = true,
            },
          },
        },
        filters = {
          dotfiles = false,
        },
      })
    end,
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
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
          lualine_x = { "encoding", "fileformat", "filetype" },
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
        { "<leader>d", group = "Diagnostics/Debug/Detour" },
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
