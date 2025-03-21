vim.g.copilot_no_tab_map = true

vim.keymap.set('i', '<C-j>', 'copilot#Accept("\\<CR>")', {
    expr = true,
    replace_keycodes = false,
})

vim.keymap.set('i', '<C-l>', '<Plug>(copilot-accept-word)')

