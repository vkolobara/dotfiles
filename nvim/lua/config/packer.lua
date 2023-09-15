local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({
            'git',
            'clone',
            '--depth', '1',
            'https://github.com/wbthomason/packer.nvim',
            install_path
        })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'

    use 'neovim/nvim-lspconfig'
    use 'nvim-lua/lsp-status.nvim'

    use 'RishabhRD/popfix'
    use 'RishabhRD/nvim-lsputils'

    use 'ms-jpq/coq_nvim'
    use {
        'ms-jpq/coq.thirdparty',
        branch = '3p'
    }

    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.1',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    use {
        'olimorris/onedarkpro.nvim'
    }

    use 'NvChad/nvim-colorizer.lua'

    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }

    use 'mfussenegger/nvim-dap'
    use 'rcarriga/nvim-dap-ui'

    use 'leoluz/nvim-dap-go'

    use 'tpope/vim-fugitive'
    use 'tpope/vim-surround'

    use 'nvim-tree/nvim-tree.lua'
    use 'nvim-tree/nvim-web-devicons'
    use 'lewis6991/gitsigns.nvim'
    use 'romgrk/barbar.nvim'

    use 'xiyaowong/transparent.nvim'

    use { 'catppuccin/nvim', as = 'catppuccin' }

    use 'preservim/nerdcommenter'
    use 'lukas-reineke/indent-blankline.nvim'

    use {
        'windwp/nvim-autopairs',
        config = function()
            return require('nvim-autopairs').setup {
                map_bs = false, map_cr = false,
            }
        end
    }

    use 'folke/neodev.nvim'
    use {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup()
        end
    }

    use {
        "akinsho/toggleterm.nvim",
        config = function() return require('toggleterm').setup() end
    }

    use { 'kevinhwang91/nvim-ufo', requires = 'kevinhwang91/promise-async' }


    use 'tpope/vim-sleuth'
    use {
        'folke/todo-comments.nvim',
        config = function()
            require('todo-comments').setup()
        end
    }

    use 'nvim-treesitter/nvim-treesitter-context'

    use 'NycRat/todo.nvim'

    use'simrat39/symbols-outline.nvim'

    if packer_bootstrap then
        require('packer').sync()
    end

    require('packer').install()
end)
