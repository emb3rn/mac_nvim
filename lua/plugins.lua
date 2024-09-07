vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	--Packer	
	use 'wbthomason/packer.nvim'
	--Syntax Highlighting
	use 'nvim-treesitter/nvim-treesitter'
	--Themes
	use {"xero/miasma.nvim"}
	use {"ellisonleao/gruvbox.nvim"}
	use {"navarasu/onedark.nvim"}
	use {"xiyaowong/transparent.nvim"}
	--Fuzzy Finder	
	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.6',
		requires = { {'nvim-lua/plenary.nvim'}}
	}
	--LSP/Autocomplete
	use {
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v3.x',
		requires = {
			--- Uncomment the two plugins below if you want to manage the language servers from neovim
			{'williamboman/mason.nvim'},
			{'williamboman/mason-lspconfig.nvim'},

			{'neovim/nvim-lspconfig'},
			{'hrsh7th/nvim-cmp'},
			{'hrsh7th/cmp-nvim-lsp'},
			{'L3MON4D3/LuaSnip'},
		}
	}
	use {
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup {
				enable_check_bracket_line = true,
				ignored_next_char = "[%w%.]"
			}
		end
	}
	-- Github Copilot#
	use {"github/copilot.vim"}
	-- Undo Trees
	use {"mbbill/undotree"}
end)
