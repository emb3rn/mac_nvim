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
		requires = { {'nvim-lua/plenary.nvim'} }
	}
	--LSP/Autocomplete
	use "williamboman/mason.nvim"
	use "williamboman/mason-lspconfig.nvim"

	use 'neovim/nvim-lspconfig'
	use 'hrsh7th/nvim-cmp'
	use 'hrsh7th/cmp-nvim-lsp'
	use 'L3MON4D3/LuaSnip'
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
	-- LSP Signature Help
	use {'ray-x/lsp_signature.nvim'}
	-- Github Copilot
	use {"github/copilot.vim"}
	-- Undo Trees
	use "mbbill/undotree"
	---Harpoon
	use {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    requires = { {"nvim-lua/plenary.nvim"} }
}
end)
