vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>') 

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = event.buf}
	
    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', '<leader>df', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', '<leader>us', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
	vim.keymap.set('n', 'sh', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  end
})

local cmp = require('cmp')
cmp.setup({
	sources = {
		{name = 'nvim_lsp'},
		{name = 'nvim_lsp_signature_help'}
	},
	mapping = {
		['<Enter>'] = cmp.mapping.confirm({select = false}),
		['<C-e>'] = cmp.mapping.abort(),
		['<C-m>'] = cmp.mapping.select_prev_item({behavior = 'select'}),
		['<C-n>'] = cmp.mapping.select_next_item({behavior = 'select'}),
		['<C-k>'] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_prev_item({behavior = 'insert'})
			else
				cmp.complete()
			end
		end),
		['<C-j>'] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_next_item({behavior = 'insert'})
			else
				cmp.complete()
			end
		end),
	},
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end,
	},
	completion = {
		completeopt = 'menu,menuone,noinsert'
	}
})

-- to learn how to use mason.nvim
-- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guide/integrate-with-mason-nvim.md
require('mason').setup({})

require('mason-lspconfig').setup({
	ensure_installed = {"clangd", "rust_analyzer", "pyright"},
	handlers = {
		function(server_name)
			if server_name == "tsserver" then
				server_name = "ts_ls"
			end
			require('lspconfig')[server_name].setup({})
		end
	}
})

require("mason-lspconfig").setup_handlers({
	function(server_name)
		if server_name == "tsserver" then
			server_name = "ts_ls"
		end
	end
})
