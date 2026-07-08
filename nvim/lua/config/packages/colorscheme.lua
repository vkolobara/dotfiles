vim.pack.add({
  "https://github.com/bluz71/vim-moonfly-colors"
})

vim.cmd([[
          if has('termguicolors')
            set termguicolors
          endif
          colorscheme moonfly
]])
