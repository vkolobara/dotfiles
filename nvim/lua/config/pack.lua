vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.clipboard = "unnamedplus"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.swapfile = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.wrap = false
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true
vim.opt.breakindent = true

vim.opt.updatetime = 250

vim.opt.signcolumn = "yes"
vim.opt.conceallevel = 1

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.api.nvim_create_user_command("WeztermSplitVertical",
  function()
    local oil_cwd = require("oil").get_current_dir()
    require("wezterm").split_pane.vertical({ cwd = oil_cwd })
  end, {})

vim.api.nvim_create_user_command("WeztermSplitHorizontal",
  function()
    local oil_cwd = require("oil").get_current_dir()
    require("wezterm").split_pane.horizontal({ cwd = oil_cwd })
  end, {})

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'nvim-treesitter' and kind == 'update' then
      if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
      vim.cmd('TSUpdate')
    end
  end
})

vim.pack.add({
  "https://github.com/ibhagwan/fzf-lua",
  { src = "https://github.com/nvim-treesitter/nvim-treesitter",        version = "main" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
  "https://github.com/stevearc/oil.nvim",

  "https://github.com/neovim/nvim-lspconfig",

  "https://github.com/rafamadriz/friendly-snippets",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/mason-org/mason-lspconfig.nvim",

  "https://github.com/stevearc/conform.nvim",

  "https://github.com/kevinhwang91/promise-async",
  "https://github.com/kevinhwang91/nvim-ufo",

  "https://github.com/j-hui/fidget.nvim",
  "https://github.com/willothy/wezterm.nvim",

  "https://github.com/windwp/nvim-autopairs",
  "https://github.com/lewis6991/gitsigns.nvim",

  "https://github.com/folke/snacks.nvim",
  "https://github.com/rebelot/kanagawa.nvim",
  "https://github.com/sindrets/diffview.nvim",
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/jay-babu/mason-nvim-dap.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/numToStr/Comment.nvim",

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

require('lualine').setup {
  sections = {
    lualine_c = { { 'filename', path = 1 } },
  }
}
vim.cmd([[
          if has('termguicolors')
            set termguicolors
          endif
          colorscheme kanagawa
]])

require("snacks").setup {
  bigfile = { enabled = true },
  quickfile = { enabled = true },
  lazygit = { configure = true },
  indent = { enabled = true },
}

vim.keymap.set('n', '<leader>gg', function() Snacks.lazygit() end, {})
vim.keymap.set('n', '<leader>gB', function() Snacks.gitbrowse() end, {})
vim.keymap.set('n', '<leader>gl', function() Snacks.lazygit.log() end, {})

require("fidget").setup {}
require("nvim-autopairs").setup {}

local fzflua = require("fzf-lua")
fzflua.register_ui_select()

vim.keymap.set('n', '<leader>pf', fzflua.files, {})
vim.keymap.set('n', '<leader>pg', fzflua.live_grep, {})
vim.keymap.set('n', '<leader>po', fzflua.lsp_document_symbols, {})
vim.keymap.set('n', '<leader>pb', fzflua.buffers, {})
vim.keymap.set('n', '<leader>ca', fzflua.lsp_code_actions, {})
vim.keymap.set('n', '<leader>rr', fzflua.lsp_references, {})
vim.keymap.set("n", "<leader>ws", fzflua.lsp_live_workspace_symbols, {})
vim.keymap.set('n', 'gD', fzflua.lsp_declarations, {})
vim.keymap.set("n", "gd", fzflua.lsp_definitions, {})
vim.keymap.set("n", "gi", fzflua.lsp_implementations, {})

vim.keymap.set("n", "<leader>d", fzflua.diagnostics_document, {})
vim.keymap.set("n", "<leader>D", fzflua.diagnostics_workspace, {})

require("oil").setup()
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

require("mason").setup()
require("mason-lspconfig").setup()

require("conform").setup({
  formatters_by_ft = {
    python = { "isort", "black" },
    cs = { "csharpier" },
    go = { "gofmt" },
    elixir = { "mix", args = "format", "--stdin", "$FILENAME" },
    sql = { "sql_formatter" },
  },
  default_format_opts = {
    lsp_format = "fallback",
  },
})

vim.keymap.set("n", "<leader>f", function()
  require("conform").format({ async = true })
end, { desc = "Format code" })

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

-- local lsp = require("lspconfig")

-- require('mason-lspconfig').setup({
--   handlers = {
--     function(server_name)
--       local capabilities = blink.get_lsp_capabilities()
--       lsp[server_name].setup(capabilities)
--     end,
--   },
-- })


require('mason').setup({
  registries = {
    "github:mason-org/mason-registry",
    "github:Crashdummyy/mason-registry",
  },
})

-- vim.g.copilot_no_tab_map = true
-- vim.g.copilot_enabled = false

-- vim.keymap.set('i', '<C-l>', '<Plug>(copilot-suggest)')
-- vim.keymap.set('i', '<C-j>', 'copilot#Accept("\\<CR>")', {
--   expr = true,
--   replace_keycodes = false,
-- })
--
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

vim.o.foldcolumn = '1'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

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

vim.api.nvim_create_autocmd('FileType', {
  callback = function(ev)
    local filetype = ev.match
    local lang = vim.treesitter.language.get_lang(filetype)
    if vim.treesitter.language.add(lang) then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      vim.treesitter.start()
    end
  end,
})

require("nvim-treesitter").setup()
require("treesitter-context").setup({

})
--
require('ufo').setup()
