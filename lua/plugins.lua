-- Bootstrap packer.nvim on a fresh machine/clone where it isn't installed yet.
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    bootstrap = true
    vim.fn.system({
        'git', 'clone', '--depth', '1',
        'https://github.com/wbthomason/packer.nvim',
        install_path,
    })
end

vim.cmd([[packadd packer.nvim]])

local packer = require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    -- Syntax highlighting
    use 'nvim-treesitter/nvim-treesitter'
    use 'nvim-treesitter/nvim-treesitter-textobjects'

    -- Theme
    use { 'projekt0n/github-nvim-theme' }

    -- Git integration
    use 'lewis6991/gitsigns.nvim'

    -- File explorer
    use 'nvim-tree/nvim-tree.lua'
    use 'nvim-tree/nvim-web-devicons'

    -- Fuzzy finder
    use {
        'nvim-telescope/telescope.nvim',
        requires = { { 'nvim-lua/plenary.nvim' } },
    }
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    use { 'nvim-telescope/telescope-frecency.nvim', version = '*' } -- ranks files by frequency+recency of access

    -- Lua development (type hints/signatures for the Neovim Lua API)
    use {
        'folke/lazydev.nvim',
        ft = 'lua',
    }
    use { 'Bilal2453/luvit-meta', lazy = true } -- optional `vim.uv` typings

    -- LSP / autocomplete
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'
    use 'neovim/nvim-lspconfig'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'onsails/lspkind.nvim' -- kind icons (function/variable/etc) in the cmp menu
    use 'L3MON4D3/LuaSnip'
    use { 'ray-x/lsp_signature.nvim' }

    -- Linting
    use 'mfussenegger/nvim-lint'

    -- Brackets
    use {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        config = function()
            require('nvim-autopairs').setup({
                enable_check_bracket_line = true,
                ignored_next_char = '[%w%.]',
            })
        end,
    }

    use 'utilyre/sentiment.nvim'

    -- AI assistance. Ghost-text completions and Next Edit Suggestions both
    -- go through the single `copilot` LSP client (see lsp.lua/sidekick.lua)
    -- rather than running copilot.vim's separate bundled client alongside it.
    use { 'folke/sidekick.nvim' }

    use 'mbbill/undotree'

    use {
        'ThePrimeagen/harpoon',
        branch = 'harpoon2',
        requires = { { 'nvim-lua/plenary.nvim' } },
    }

    use({
        'nvim-neo-tree/neo-tree.nvim',
        branch = 'v3.x',
        requires = {
            'nvim-lua/plenary.nvim',
            'MunifTanjim/nui.nvim',
            'nvim-tree/nvim-web-devicons', -- optional, but recommended
        },
    })

    use 'rcarriga/nvim-notify'
    use 'gelguy/wilder.nvim' -- cmdline autocomplete

    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true },
    }
    use { 'akinsho/bufferline.nvim', requires = { 'nvim-tree/nvim-web-devicons', opt = true } }

    if bootstrap then
        require('packer').sync()
    end
end)

return packer
