local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

return require("lazy").setup({
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',

    'nvim-lua/lsp-status.nvim',
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        dependencies = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        }
    },

    'RishabhRD/popfix',
    'RishabhRD/nvim-lsputils',

    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate'
    },

    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = { { 'nvim-lua/plenary.nvim' } }
    },

    {
        'nvim-lualine/lualine.nvim',
    },

    'mfussenegger/nvim-dap',
    {
        'rcarriga/nvim-dap-ui',
        tag = 'v3.9.3'
    },

    'leoluz/nvim-dap-go',

    'tpope/vim-fugitive',
    'tpope/vim-surround',

    'nvim-tree/nvim-web-devicons',
    'lewis6991/gitsigns.nvim',
    'romgrk/barbar.nvim',

    'xiyaowong/transparent.nvim',

    {
        'rebelot/kanagawa.nvim',
        as = 'kanagawa',
        config = function()
            return require('kanagawa').setup {
                theme = "lotus"
            }
        end
    },

    'preservim/nerdcommenter',
    'lukas-reineke/indent-blankline.nvim',

    {
        'windwp/nvim-autopairs',
        config = function()
            return require('nvim-autopairs').setup {
                map_bs = false, map_cr = false,
            }
        end
    },

    'folke/neodev.nvim',
    {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup()
        end
    },

    {
        "akinsho/toggleterm.nvim",
        config = function() return require('toggleterm').setup() end
    },

    { 'kevinhwang91/nvim-ufo', dependencies = 'kevinhwang91/promise-async' },


    'tpope/vim-sleuth',
    {
        'folke/todo-comments.nvim',
        config = function()
            require('todo-comments').setup()
        end
    },

    'nvim-treesitter/nvim-treesitter-context',

    'NycRat/todo.nvim',
    {
        'supermaven-inc/supermaven-nvim',
        config = function()
            require("supermaven-nvim").setup({
                keymaps = {
                    accept_suggestion = "<C-j>",
                    clear_suggestion  = "<C-]>",
                    accept_word       = "<C-J>",
                },
                disable_keymaps = true,
            })
            local completion_preview = require("supermaven-nvim.completion_preview")
            vim.keymap.set('i', '<c-j>', completion_preview.on_accept_suggestion,
                { noremap = true, silent = true })
            vim.keymap.set('i', '<c-h>', completion_preview.on_accept_suggestion_word,
                { noremap = true, silent = true })
            vim.keymap.set('i', '<c-]>', completion_preview.on_accept_suggestion_word,
                { noremap = true, silent = true })
        end,
    },


    'simrat39/symbols-outline.nvim',
    'nvimtools/none-ls.nvim',
    'jay-babu/mason-null-ls.nvim',
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
        },
    },
    {
        'stevearc/dressing.nvim',
        opts = {},
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
        }
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && yarn install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    },
    "numToStr/FTerm.nvim",
    {
        "nkakouros-original/numbers.nvim",
        config = function() return require('numbers').setup() end
    },
    {
        "towolf/vim-helm", ft = 'helm',
    },
    "b0o/schemastore.nvim",
    {
        "prichrd/netrw.nvim",
        config = function() require("netrw").setup() end
    },
    {
        'stevearc/dressing.nvim',
        opts = {},
    },
    {
        "ariel-frischer/bmessages.nvim",
        event = "CmdlineEnter",
        opts = {}
    },
    {
        "karb94/neoscroll.nvim",
        config = function()
            require('neoscroll').setup({})
        end
    },
    {
        "m4xshen/hardtime.nvim",
        dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
        opts = {}
    },
})
