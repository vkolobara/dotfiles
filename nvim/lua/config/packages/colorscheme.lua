vim.pack.add({
  "https://github.com/rebelot/kanagawa.nvim"
})

vim.cmd([[
          if has('termguicolors')
            set termguicolors
          endif
          colorscheme kanagawa
]])
