vim.pack.add({
  "https://github.com/j-hui/fidget.nvim",

  "https://github.com/windwp/nvim-autopairs",
  "https://github.com/lewis6991/gitsigns.nvim",

  "https://github.com/sindrets/diffview.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
})

require("fidget").setup {}
require("nvim-autopairs").setup {}

require("config.packages.fzf")
require("config.packages.wezterm")
require("config.packages.oil")
require("config.packages.treesitter")
require("config.packages.lsp")
require("config.packages.comment")
require("config.packages.lualine")
require("config.packages.colorscheme")
require("config.packages.snacks")
require("config.packages.conform")
require("config.packages.ufo")
require("config.packages.dadbod")
require("config.packages.dap")
