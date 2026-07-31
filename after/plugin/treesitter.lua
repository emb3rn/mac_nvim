local languages = { 'c', 'lua', 'vim', 'vimdoc', 'query', 'python' }
local treesitter = require('nvim-treesitter')

treesitter.setup({
    install_dir = vim.fn.stdpath('data') .. '/site',
})

-- Parser builds require the tree-sitter CLI. Keep the editor usable before it
-- is installed; parsers can be installed later with :TSInstall.
if vim.fn.executable('tree-sitter') == 1 then
    treesitter.install(languages)
end

local textobjects = require('nvim-treesitter-textobjects')
textobjects.setup({
    select = {
        lookahead = true,
    },
})

local select_textobject = require('nvim-treesitter-textobjects.select').select_textobject
vim.keymap.set({ 'x', 'o' }, 'af', function()
    select_textobject('@function.outer', 'textobjects')
end, { desc = 'Treesitter: Select Function' })
vim.keymap.set({ 'x', 'o' }, 'if', function()
    select_textobject('@function.inner', 'textobjects')
end, { desc = 'Treesitter: Select Inner Function' })
vim.keymap.set({ 'x', 'o' }, 'ac', function()
    select_textobject('@class.outer', 'textobjects')
end, { desc = 'Treesitter: Select Class' })
vim.keymap.set({ 'x', 'o' }, 'ic', function()
    select_textobject('@class.inner', 'textobjects')
end, { desc = 'Treesitter: Select Inner Class' })

vim.api.nvim_create_autocmd('FileType', {
    pattern = languages,
    callback = function(args)
        local ok = pcall(vim.treesitter.start, args.buf)
        if not ok then
            return
        end
        vim.wo.foldmethod = 'expr'
        vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.wo.foldlevel = 99
    end,
})

vim.keymap.set('n', '<leader>fa', 'zM', { desc = 'Fold all', silent = true })
vim.keymap.set('n', '<leader>ua', 'zR', { desc = 'Unfold all', silent = true })
vim.keymap.set('n', '<leader>fd', 'za', { desc = 'Toggle fold under cursor', silent = true })
