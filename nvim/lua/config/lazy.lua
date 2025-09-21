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
vim.opt.conceallevel = 1

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    {
      "sainnhe/everforest",
      opts = {
      },
      config = function(_, opts)
        vim.cmd([[
          if has('termguicolors')
            set termguicolors
          endif
          set background=dark
          let g:everforest_background='hard'
          let g:everforest_better_performance = 1
          colorscheme everforest
        ]])
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
      "seblyng/roslyn.nvim",
      ---@module 'roslyn.config'
      ---@type RoslynNvimConfig
      opts = {
        -- your configuration comes here; leave empty for default settings
      },
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
    },
    {
      "epwalsh/obsidian.nvim",
      version = "*", -- recommended, use latest release instead of latest commit
      lazy = false,
      ft = "markdown",
      keys = {
        { "<leader>ow",  mode = "n", "<cmd>ObsidianWorkspace<cr>",   desc = "Obsidian Worskpace" },
        { "<leader>of",  mode = "n", "<cmd>ObsidianQuickSwitch<cr>", desc = "Obsidian Find Note" },

        { "<leader>on",  mode = "n", "<cmd>ObsidianNew<cr>",         desc = "Obsidian New Note" },
        { "<leader>oN",  mode = "v", ":ObsidianExtractNote<cr>",     desc = "Obsidian New Note From Selection" },

        { "<leader>oL",  mode = "n", "<cmd>ObsidianBacklinks<cr>",   desc = "Obsidian Back Links" },
        { "<leader>ot",  mode = "n", "<cmd>ObsidianTags<cr>",        desc = "Obsidian Tags" },

        { "<leader>oy",  mode = "n", "<cmd>ObsidianYesterday<cr>",   desc = "Obsidian Yesterday" },
        { "<leader>od",  mode = "n", "<cmd>ObsidianToday<cr>",       desc = "Obsidian Daily" },
        { "<leader>ot",  mode = "n", "<cmd>ObsidianTomorrow<cr>",    desc = "Obsidian Tomorrow" },
        { "<leader>ogd", mode = "n", "<cmd>ObsidianDailies<cr>",     desc = "Obsidian Daily List" },

        { "<leader>ol",  mode = "v", "<cmd>ObsidianLink<cr>",        desc = "Obsidian Link" },
        { "<leader>ogl", mode = "n", "<cmd>ObsidianFollowLink<cr>",  desc = "Obsidian Link List" },

        { "<leader>orn", mode = "n", ":ObsidianRename<cr>",          desc = "Obsidian Rename" },
      },
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
      opts = {
        follow_url_func = function(url)
          if vim.loop.os_uname().sysname == "Linux" then
            vim.fn.jobstart({ "xdg-open", url })
          elseif vim.loop.os_uname().sysname == "Darwin" then
            vim.fn.jobstart({ "open", url })
          else
            error("unsupported os")
          end
        end,
        pickers = {
          name = "fzf-lua"
        },
        workspaces = {
          {
            name = "vinko",
            path = "~/vaults/vinko",
          },
        },
      },
      config = function(_, opts)
        require('obsidian').setup(opts)
      end
    },
    {
      "kevinhwang91/nvim-ufo",
      dependencies = {
        "kevinhwang91/promise-async"
      },
    },
    {
      "mistweaverco/kulala.nvim",
      keys = {
        { "<leader>Rs", desc = "Send request" },
        { "<leader>Ra", desc = "Send all requests" },
        { "<leader>Rb", desc = "Open scratchpad" },
      },
      ft = { "http", "rest" },
      opts = {
        global_keymaps = true,
        global_keymaps_prefix = "<leader>R",
        kulala_keymaps_prefix = "",
      },
    },
    {
        'nvim-flutter/flutter-tools.nvim',
        lazy = false,
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
        config = true,
    }

  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "everforest" } },
  -- automatically check for plugin updates
  checker = { enabled = false },
})
