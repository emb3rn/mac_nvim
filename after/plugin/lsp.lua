local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
	-- see :help lsp-zero-keybindings
	-- to learn the available actions
	lsp_zero.default_keymaps({buffer = bufnr})
	vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
	vim.keymap.set('n', '<leader>df', vim.lsp.buf.definition, opts)
	vim.keymap.set('n', '<leader>us::', vim.lsp.buf.references, opts)
end)


local cmp = require('cmp')
cmp.setup({
	sources = {
		{name = 'nvim_lsp'},
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
	ensure_installed = {"clangd", "rust_analyzer", "pyright", "tssserver"},
	handlers = {
		function(server_name)
			if server_name == "tssserver" then
				server_name = "ts_ls"
			end
			require('lspconfig')[server_name].setup({})
		end,
	},
})
