-- Set leader key before anything else
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Load core configuration
require("core.options")
require("core.keymaps")
require("core.lazy")
