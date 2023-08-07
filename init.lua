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

require("clangd_extensions").setup {
  server = {
    cmd = {"clangd", "--all-scopes-completion=1", "--clang-tidy=1", "--header-insertion=iwyu", "--enable-config"}
  },
  extensions = {
    -- defaults:
    -- Automatically set inlay hints (type hints)
    autoSetHints = true,
    -- These apply to the default ClangdSetInlayHints command
    inlay_hints = {
      inline = vim.fn.has("nvim-0.10") == 1,
      -- Options other than `highlight' and `priority' only work
      -- if `inline' is disabled
      -- Only show inlay hints for the current line
      only_current_line = false,
      -- Event which triggers a refersh of the inlay hints.
      -- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
      -- not that this may cause  higher CPU usage.
      -- This option is only respected when only_current_line and
      -- autoSetHints both are true.
      only_current_line_autocmd = "CursorHold",
      -- whether to show parameter hints with the inlay hints or not
      show_parameter_hints = true,
      -- prefix for parameter hints
      parameter_hints_prefix = "<- ",
      -- prefix for all the other hints (type, chaining)
      other_hints_prefix = "=> ",
      -- whether to align to the length of the longest line in the file
      max_len_align = false,
      -- padding from the left if max_len_align is true
      max_len_align_padding = 1,
      -- whether to align to the extreme right or not
      right_align = false,
      -- padding from the right if right_align is true
      right_align_padding = 7,
      -- The color of the hints
      highlight = "Comment",
      -- The highlight group priority for extmark
      priority = 100,
    },
    ast = {
      -- These are unicode, should be available in any font
      role_icons = {
        type = "🄣",
        declaration = "🄓",
        expression = "🄔",
        statement = ";",
        specifier = "🄢",
        ["template argument"] = "🆃",
      },
      kind_icons = {
        Compound = "🄲",
        Recovery = "🅁",
        TranslationUnit = "🅄",
        PackExpansion = "🄿",
        TemplateTypeParm = "🅃",
        TemplateTemplateParm = "🅃",
        TemplateParamObject = "🅃",
      },
      --[[ These require codicons (https://github.com/microsoft/vscode-codicons)
            role_icons = {
                type = "",
                declaration = "",
                expression = "",
                specifier = "",
                statement = "",
                ["template argument"] = "",
            },

            kind_icons = {
                Compound = "",
                Recovery = "",
                TranslationUnit = "",
                PackExpansion = "",
                TemplateTypeParm = "",
                TemplateTemplateParm = "",
                TemplateParamObject = "",
            }, ]]

      highlights = {
        detail = "Comment",
      },
    },
    memory_usage = {
      border = "none",
    },
    symbol_info = {
      border = "none",
    },
  },
}

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
