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
        tag = '0.1.1',
        dependencies = { { 'nvim-lua/plenary.nvim' } }
    },

    {
        'nvim-lualine/lualine.nvim',
    },

    'mfussenegger/nvim-dap',
    'rcarriga/nvim-dap-ui',

    'leoluz/nvim-dap-go',

    'tpope/vim-fugitive',
    'tpope/vim-surround',

    'nvim-tree/nvim-tree.lua',
    'nvim-tree/nvim-web-devicons',
    'lewis6991/gitsigns.nvim',
    'romgrk/barbar.nvim',

    'xiyaowong/transparent.nvim',

    {
        'rose-pine/neovim',
        as = 'rose-pine',
        config = function()
            vim.cmd('colorscheme rose-pine')
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

    'simrat39/symbols-outline.nvim',
    'jose-elias-alvarez/null-ls.nvim',
    'jay-babu/mason-null-ls.nvim',
    'github/copilot.vim'

})
