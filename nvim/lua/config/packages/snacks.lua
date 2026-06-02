vim.pack.add({
  "https://github.com/folke/snacks.nvim",
})

require("snacks").setup {
  bigfile = { enabled = true },
  quickfile = { enabled = true },
  lazygit = { configure = true },
  indent = { enabled = true },
}

vim.keymap.set('n', '<leader>gg', function() Snacks.lazygit() end, {})
vim.keymap.set('n', '<leader>gB', function() Snacks.gitbrowse() end, {})
vim.keymap.set('n', '<leader>gl', function() Snacks.lazygit.log() end, {})
