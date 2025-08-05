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

local coq = require "coq"
local lsp = require "lspconfig"

require('mason-lspconfig').setup({
  handlers = {
    function(server_name)
      lsp[server_name].setup(coq.lsp_ensure_capabilities())
     end,
  }
})
