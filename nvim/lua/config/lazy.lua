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

return require("lazy").setup(
    {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-nvim-lsp',
        'neovim/nvim-lspconfig',

        'nvim-lua/lsp-status.nvim',

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

        { 'kevinhwang91/nvim-ufo', dependencies = 'kevinhwang91/promise-async' },


        {
            'folke/todo-comments.nvim',
            config = function()
                require('todo-comments').setup()
            end
        },

        'nvim-treesitter/nvim-treesitter-context',

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
            "nkakouros-original/numbers.nvim",
            config = function() return require('numbers').setup() end
        },
        {
            "towolf/vim-helm", ft = 'helm',
        },
        {
            "folke/trouble.nvim",
            opts = {}, -- for default options, refer to the configuration section for custom setup.
            cmd = "Trouble",
            keys = {
                {
                    "<leader>xx",
                    "<cmd>Trouble diagnostics toggle<cr>",
                    desc = "Diagnostics (Trouble)",
                },
                {
                    "<leader>xX",
                    "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                    desc = "Buffer Diagnostics (Trouble)",
                },
                {
                    "<leader>cs",
                    "<cmd>Trouble symbols toggle focus=false<cr>",
                    desc = "Symbols (Trouble)",
                },
                {
                    "<leader>cl",
                    "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                    desc = "LSP Definitions / references / ... (Trouble)",
                },
                {
                    "<leader>xL",
                    "<cmd>Trouble loclist toggle<cr>",
                    desc = "Location List (Trouble)",
                },
                {
                    "<leader>xQ",
                    "<cmd>Trouble qflist toggle<cr>",
                    desc = "Quickfix List (Trouble)",
                },
            },
        },
        {
            "stevearc/oil.nvim",
            opts = {},
            config = function()
                require("oil").setup()
            end
        },
        {
            "j-hui/fidget.nvim",
            opts = {},
            config = function()
                require("fidget").setup({})
            end
        },
        {
            "kevinhwang91/nvim-bqf",
        },
        {
            "NeogitOrg/neogit",
            dependencies = {
                "nvim-lua/plenary.nvim",  -- required
                "sindrets/diffview.nvim", -- optional - Diff integration
            },
            config = true
        },
        {
            'kristijanhusak/vim-dadbod-ui',
            dependencies = {
                { 'tpope/vim-dadbod',                     lazy = true },
                { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true }, -- Optional
            },
            cmd = {
                'DBUI',
                'DBUIToggle',
                'DBUIAddConnection',
                'DBUIFindBuffer',
            },
            init = function()
                -- Your DBUI configuration
                vim.g.db_ui_use_nerd_fonts = 1
            end,
        },
        {
            'MeanderingProgrammer/render-markdown.nvim',
            dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
            ---@module 'render-markdown'
            ---@type render.md.UserConfig
            opts = {}
        },
        {
            'stevearc/conform.nvim',
            opts = {},
            config = function() require('conform').setup({
                formatters_by_ft = {
                    python = {"isort", "black"},
                    go = {"gofmt"},
                    elixir = {"mix", args="format", "--stdin", "$FILENAME"},
                },
            }) end
        },
        {
            'mistweaverco/kulala.nvim',
            opts = {}
        },
        {
            "danymat/neogen",
            config = true,
            -- Uncomment next line if you want to follow only stable versions
            -- version = "*"
        },
        {
            'Bekaboo/dropbar.nvim',
            -- optional, but required for fuzzy finder support
            dependencies = {
                'nvim-telescope/telescope-fzf-native.nvim'
            }
        },
        {
            'echasnovski/mini.ai',
            version = false,
            config = function() require('mini.ai').setup() end
        },
        {
            "L3MON4D3/LuaSnip",
            -- follow latest release.
            version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
            -- install jsregexp (optional!).
            build = "make install_jsregexp"
        }
    }
)
