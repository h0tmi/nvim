return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false, -- treesitter does not support lazy-loading
  build = ":TSUpdate",
  config = function()
    -- Setup treesitter
    require("nvim-treesitter").setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    -- Install parsers
    local parsers = {
      "lua", "vim", "vimdoc", "query",
      "c", "cpp",
      "go",
      "python",
      "bash",
      "javascript", "typescript",
      "json", "yaml", "toml",
      "html", "css",
      "markdown", "markdown_inline",
      "rust",
    }
    require("nvim-treesitter").install(parsers)

    -- Enable highlighting for supported filetypes only
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "lua", "vim", "vimdoc", "query",
        "c", "cpp",
        "go",
        "python",
        "bash", "sh",
        "javascript", "typescript",
        "json", "yaml", "toml",
        "html", "css",
        "markdown",
        "rust",
      },
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })

    -- Enable indentation for specific filetypes
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "lua", "python", "c", "cpp", "go", "javascript", "typescript", "rust" },
      callback = function()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
