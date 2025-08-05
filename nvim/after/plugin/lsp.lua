vim.keymap.set("n", "<leader>f", function()
  require("conform").format({ async = true })
end, { desc = "Format code" })

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'Enable LSP actions',
    callback = function(event)
      local opts = { buffer = event.buf }
      vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
      vim.keymap.set("i", "<C-k>", function() vim.lsp.buf.signature_help() end, opts)
      vim.keymap.set("n", "<leader>e", function() vim.diagnostic.open_float() end, opts)
      vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
      vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
      vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
    end,
})

local blink = require("blink.cmp")
local lsp = require "lspconfig"

require('mason-lspconfig').setup({
  handlers = {
    function(server_name)
      local capabilities = blink.get_lsp_capabilities()
      lsp[server_name].setup(capabilities)
     end,
  }
})

vim.g.copilot_no_tab_map = true
vim.g.copilot_enabled = false

vim.keymap.set('i', '<C-l>', '<Plug>(copilot-suggest)')
vim.keymap.set('i', '<C-j>', 'copilot#Accept("\\<CR>")', {
    expr = true,
    replace_keycodes = false,
})

