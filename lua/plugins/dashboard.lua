return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("dashboard").setup({
      theme = "doom",
      config = {
        header = {
          "",
          "",
          "",
          " ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
          " ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
          " ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
          " ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
          " ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
          " ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
          "",
          "",
        },
        center = {
          {
            icon = "  ",
            icon_hl = "Title",
            desc = "Find File           ",
            desc_hl = "String",
            key = "f",
            key_hl = "Number",
            action = "FzfLua files",
          },
          {
            icon = "  ",
            icon_hl = "Title",
            desc = "Recent Files        ",
            desc_hl = "String",
            key = "r",
            key_hl = "Number",
            action = "FzfLua oldfiles",
          },
          {
            icon = "  ",
            icon_hl = "Title",
            desc = "Find Text           ",
            desc_hl = "String",
            key = "g",
            key_hl = "Number",
            action = "FzfLua live_grep",
          },
          {
            icon = "  ",
            icon_hl = "Title",
            desc = "Config              ",
            desc_hl = "String",
            key = "c",
            key_hl = "Number",
            action = "edit ~/.config/nvim/init.lua",
          },
          {
            icon = "  ",
            icon_hl = "Title",
            desc = "Quit                ",
            desc_hl = "String",
            key = "q",
            key_hl = "Number",
            action = "qa",
          },
        },
        footer = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          return {
            "",
            "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms",
          }
        end,
      },
    })
  end,
}
