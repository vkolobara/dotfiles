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
            'stevearc/dressing.nvim',
            opts = {},
        },
        {
            'nvim-telescope/telescope.nvim',
            branch = '0.1.x',
            dependencies = { { 'nvim-lua/plenary.nvim' }, }
        },
        {
            'tiagovla/scope.nvim',
            config = true,
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
        {
            'romgrk/barbar.nvim',
        },
        'xiyaowong/transparent.nvim',
        {
            "tiagovla/tokyodark.nvim",
            opts = {
                -- custom options here
            },
            config = function(_, opts)
                require("tokyodark").setup(opts) -- calling setup is optional
            end,
        },

        'preservim/nerdcommenter',

        {
            'lukas-reineke/indent-blankline.nvim',
            config = function()
                require('ibl').setup()
            end
        },
        {
            'windwp/nvim-autopairs',
            event = 'InsertEnter',
            config = true,
        },

        { 'kevinhwang91/nvim-ufo', dependencies = 'kevinhwang91/promise-async' },


        {
            'folke/todo-comments.nvim',
            config = function()
                require('todo-comments').setup()
            end
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
                    command  = "dotnet",
                    args = { "tool", "run", "csharpier", "format", "--write-stdout", "$FILENAME" }
                }
            end
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
        },
        {
            "folke/snacks.nvim",
            priority = 1000,
            lazy = false,
            opts = {
                bigfile = { enabled = true },
                quickfile = { enabled = true },
                lazygit = { configure = true },
            },
            keys = {
                { "<leader>gg", function() Snacks.lazygit() end,     desc = "Lazygit" },
                { "<leader>gB", function() Snacks.gitbrowse() end,   desc = "Git Browse" },
                { "<leader>gl", function() Snacks.lazygit.log() end, desc = "Git Log" },
            }

        },
        {
            'pwntester/octo.nvim',
            requires = {
                'nvim-lua/plenary.nvim',
                'nvim-telescope/telescope.nvim',
                -- OR 'ibhagwan/fzf-lua',
                -- OR 'folke/snacks.nvim',
                'nvim-tree/nvim-web-devicons',
            },
            config = function()
                require "octo".setup()
            end
        },
        {
            'github/copilot.vim',
            config = function()
                vim.g.copilot_enabled = false
            end
        },
        {
            'CopilotC-Nvim/CopilotChat.nvim',
            build = "make tiktoken",
            opts = {}
        },
        {
            "Cliffback/netcoredbg-macOS-arm64.nvim",
        },
        {
            "folke/zen-mode.nvim"
        },
        {
            "seblyng/roslyn.nvim",
            ft = "cs",
            ---@module 'roslyn.config'
            ---@type RoslynNvimConfig
            opts = {
                -- your configuration comes here; leave empty for default settings
            },
        },
        {
            "sindrets/diffview.nvim"
        }
    }
)
