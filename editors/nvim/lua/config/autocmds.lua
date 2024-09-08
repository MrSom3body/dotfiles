-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("VimEnter", {
  group = augroup("autoupdate"),
  callback = function()
    require("lazy").update({
      show = false,
    })
  end,
})

-- Reload waybar config on save
vim.api.nvim_create_autocmd("BufWritePost", {
  group = augroup("reload_waybar"),
  pattern = "*/dotfiles/**/waybar/*",
  callback = function()
    vim.fn.system("killall waybar; waybar & disown")
    vim.notify("Reloaded waybar config", "info", { title = "waybar" })
  end,
})

-- Reload SwayNC config on save
vim.api.nvim_create_autocmd("BufWritePost", {
  group = augroup("reload_swaync"),
  pattern = "*/dotfiles/**/swaync/*",
  callback = function()
    vim.fn.system("killall swaync; swaync & disown")
    vim.notify("Reloaded SwayNC config", "info", { title = "SwayNC" })
  end,
})
