return {
  -- tell LazyVim to stop messing with colorschemes
  { "catppuccin/nvim", name = "catppuccin", enabled = false },
  { "folke/tokyonight.nvim", enabled = false },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox", -- just some random built-in scheme
    },
  },

  -- load/save our last used colorscheme automatically
  {
    "https://git.sr.ht/~swaits/colorsaver.nvim",
    event = "VimEnter",
    opts = {},
    dependencies = {
      -- load colorschemes as a dependency of colorsaver
      -- { "RRethy/base16-nvim" },
      { "ellisonleao/gruvbox.nvim" },
      { "catppuccin/nvim" },
    },
  },
}
