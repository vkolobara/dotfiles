local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath 'data' ..'/site/pack/packer/start/packer.nvim'
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
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use {
    'olimorris/onedarkpro.nvim'
  }

  use 'NvChad/nvim-colorizer.lua'

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt=true}
  }

  use 'mfussenegger/nvim-dap'

  use 'tpope/vim-fugitive'


  if packer_bootstrap then
    require('packer').sync()
  end

  require('packer').install()

end)


