-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set leader key before lazy setup
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Setup lazy.nvim
require("lazy").setup({
  -- Gruvbox Material theme
  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    config = function()
      -- Configure gruvbox-material
      vim.g.gruvbox_material_better_performance = 1

      -- Auto light/dark switching based on macOS system appearance
      local function set_theme()
        local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
        if handle then
          local result = handle:read("*a")
          handle:close()

          if result:match("Dark") then
            vim.g.gruvbox_material_background = "hard"
            vim.opt.background = "dark"
          else
            vim.g.gruvbox_material_background = "soft"
            vim.opt.background = "light"
          end
        else
          -- Default to dark if can't detect
          vim.g.gruvbox_material_background = "soft"
          vim.opt.background = "light"
        end
      end

      set_theme()
      vim.cmd.colorscheme("gruvbox-material")

      -- Auto-refresh theme every 5 seconds
      local timer = vim.loop.new_timer()
      timer:start(0, 5000, vim.schedule_wrap(function()
        local old_bg = vim.opt.background:get()
        set_theme()
        local new_bg = vim.opt.background:get()
        if old_bg ~= new_bg then
          vim.cmd.colorscheme("gruvbox-material")
        end
      end))
    end,
  },
}, {
  -- Lazy.nvim options
  ui = {
    border = "rounded",
  },
})

-- Basic Neovim settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 50
