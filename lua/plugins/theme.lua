return {
  "sainnhe/gruvbox-material",
  lazy = false,
  priority = 1000,
  config = function()
    vim.g.gruvbox_material_foreground = "material"
    vim.g.gruvbox_material_background = "hard"
    vim.g.gruvbox_material_enable_italic = 1
    vim.g.gruvbox_material_better_performance = 1

    -- Auto light/dark switching based on macOS system appearance
    local function set_theme()
      local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
      if handle then
        local result = handle:read("*a")
        handle:close()

        if result:match("Dark") then
          vim.opt.background = "dark"
        else
          vim.opt.background = "light"
        end
      else
        vim.opt.background = "dark"
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
}
