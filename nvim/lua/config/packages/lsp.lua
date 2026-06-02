vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig",

  "https://github.com/rafamadriz/friendly-snippets",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/mason-org/mason-lspconfig.nvim",
})

require('mason').setup({
  registries = {
    "github:mason-org/mason-registry",
    "github:Crashdummyy/mason-registry",
  },
})
require("mason-lspconfig").setup()

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'Enable LSP actions',
  callback = function(event)
    local opts = { buffer = event.buf }
    vim.lsp.codelens.enable(true, { bufnr = opts.buffer })
    vim.lsp.inlay_hint.enable(true, { bufnr = opts.buffer })

    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set("i", "<C-k>", function() vim.lsp.buf.signature_help() end, opts)
    vim.keymap.set("n", "<leader>e", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
  end,
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" }
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true)
      }
    }
  }
})

vim.lsp.config("expert", {
  cmd = { 'expert', '--stdio' },
  root_markers = { 'mix.exs', '.git' },
  filetypes = { 'elixir', 'eelixir', 'heex' }
})

vim.o.autocomplete = true
vim.cmd [[
	inoremap <silent><expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
	inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
]]
vim.o.pumheight = 8

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})

vim.opt.complete:append('o')
vim.opt.completeopt = { 'menuone', 'noselect' }
vim.g.omni_sql_default_compl_type = 'syntax'
