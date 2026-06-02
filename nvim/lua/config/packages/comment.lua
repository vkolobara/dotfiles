vim.pack.add({
  "https://github.com/numToStr/Comment.nvim"
})

require('Comment').setup({
  toggler = {
    line = '<leader>gc',
    block = '<leader>gb',
  },
  opleader = {
    line = '<leader>gc',
    block = '<leader>gb',
  },
  mappings = {
    basic = true,
    extra = false,
  },
})
