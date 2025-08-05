local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
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

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    --
    -- colorscheme
    {
      "tiagovla/tokyodark.nvim",
      opts = {
      },
      config = function(_, opts)
        require("tokyodark").setup(opts) -- calling setup is optional
        vim.cmd("colorscheme tokyodark")
      end,
    },
    {
      "ibhagwan/fzf-lua",
      opts = {}
    },
    {
      'nvim-treesitter/nvim-treesitter',
      lazy = false,
      branch = 'master',
      build = ':TSUpdate'
    },
    {
      "stevearc/oil.nvim",
      opts = {},
      config = function()
        require("oil").setup()
      end
    },
    {
      'saghen/blink.cmp',
      dependencies = { 'rafamadriz/friendly-snippets' },

      version = '1.*',

      ---@module 'blink.cmp'
      ---@type blink.cmp.Config
      opts = {
        keymap = {
          preset = 'default',

          ['<Tab>'] = { 'select_next', 'fallback' },
          ['<S-Tab>'] = { 'select_prev', 'fallback' },
          ['<C-Tab>'] = { 'snippet_forward', 'fallback' },
          ['<C-S-Tab>'] = { 'snippet_backward', 'fallback' },

          -- ['<Esc>'] = { 'cancel', 'fallback' },
          ['<CR>'] = { 'accept', 'fallback' },
          ['<C-space>'] = { 'show', 'fallback' },
        },

        appearance = {
          nerd_font_variant = 'mono'
        },

        completion = {
          keyword = { range = "full" },
          documentation = { auto_show = true },
          ghost_text = { enabled = true },
          accept = { auto_brackets = { enabled = false }, },
        },

        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer' },
        },
        fuzzy = { implementation = "prefer_rust" }
      },
      opts_extend = { "sources.default" }
    },
    {
      "mason-org/mason-lspconfig.nvim",
      opts = {},
      dependencies = {

        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",

      },
      init = function()
        require("mason").setup()
        require('mason-lspconfig').setup()
      end,
      config = function()
      end
    },
    {
      'stevearc/conform.nvim',
      opts = {},
      config = function()
        require('conform').setup({
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
        require('conform').formatters.csharpier = {
          command = "dotnet",
          args    = { "tool", "run", "csharpier", "format", "--write-stdout", "$FILENAME" }
        }
      end
    },
    {
      "folke/snacks.nvim",
      priority = 1000,
      lazy = false,
      opts = {
        bigfile = { enabled = true },
        quickfile = { enabled = true },
        lazygit = { configure = true },
        indent = { enabled = true },
      },
      keys = {
        { "<leader>gg", function() Snacks.lazygit() end,     desc = "Lazygit" },
        { "<leader>gB", function() Snacks.gitbrowse() end,   desc = "Git Browse" },
        { "<leader>gl", function() Snacks.lazygit.log() end, desc = "Git Log" },
      }
    },
    {
      "lewis6991/gitsigns.nvim"
    },
    {
      'nvim-lualine/lualine.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      config = function()
        require('lualine').setup {
          sections = {
            lualine_c = { { 'filename', path = 1 } },
          }
        }
      end
    },
    {
      'windwp/nvim-autopairs',
      event = "InsertEnter",
      opts = {}
    },
    {
      "github/copilot.vim"
    },
    {
      'numToStr/Comment.nvim',
      config = function()
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
      end
    }

  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "tokyodark" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
