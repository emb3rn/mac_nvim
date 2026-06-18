require('nvim-treesitter.configs').setup({
    ensure_installed = { 'c', 'lua', 'vim', 'vimdoc', 'query', 'python' },
    sync_install = false, -- only applies to ensure_installed
    auto_install = true,

    highlight = {
        enable = true,
        disable = { 'c', 'rust' },
        additional_vim_regex_highlighting = false,
    },

    textobjects = {
        select = {
            enable = true,
            lookahead = true, -- jump forward to the textobj, like targets.vim
            keymaps = {
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['ac'] = '@class.outer',
                ['ic'] = '@class.inner',
            },
        },
    },
})

-- Enable treesitter folding (uses Neovim's built-in treesitter foldexpr,
-- since nvim-treesitter's own `nvim_treesitter#foldexpr()` is buggy/deprecated
-- in favor of `vim.treesitter.foldexpr()`)
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldlevel = 99 -- open all folds by default

vim.keymap.set('n', '<leader>fa', 'zM', { desc = 'Fold all', silent = true })
vim.keymap.set('n', '<leader>ua', 'zR', { desc = 'Unfold all', silent = true })
vim.keymap.set('n', '<leader>fd', 'za', { desc = 'Toggle fold under cursor', silent = true })
