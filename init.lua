-- TRUE SETTING FOR CPP LSP
-- vim.o.ycm_extra_conf_globlist = '/home/h0tmi/arcadia/.ycm_extra_conf.py'
-- vim.o.ycm_show_diagnostics_ui = false
-- vim.o.ycm_clangd_args = '--header-insertion=never'
-- vim.o.ycm_enable_inlay_hints = false
-- vim.o.ycm_enable_diagnostic_signs = false
local uname = vim.loop.os_uname()


_G.OS = uname.sysname
_G.IS_MAC = OS == 'Darwin'
_G.IS_LINUX = OS == 'Linux'
_G.IS_WINDOWS = OS:find 'Windows' and true or false
_G.IS_WSL = (function()
  local output = vim.fn.systemlist "uname -r"
  local condition1 = IS_LINUX and uname.release:lower():find 'microsoft' and true or false
  local condition2 = not not string.find(output[1] or "", "WSL")
  return condition1 or condition2
end)()

-- Mapping leader key to: " "
vim.g.mapleader = " "

require("leonasdev.options")
require("leonasdev.keymaps")

-- Install lazy.nvim (package manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  install = {
    colorscheme = { "solarized", "habamax" }
  },
  ui = {
    border = "rounded",
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      }
    }
  }
})

require("clangd_extensions")

require("clangd_extensions.inlay_hints").setup_autocmd()
require("clangd_extensions.inlay_hints").set_inlay_hints()

-- close lazy panel with esc
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "lazy",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end
})
-- Diagnostic settings
-- vim.diagnostic.config {
--   virtual_text = false,
--   signs = false,
--   underline = false,
-- }
