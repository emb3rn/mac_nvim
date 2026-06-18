vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)
vim.keymap.set('n', '<leader>tm', ':botright terminal<CR>', { silent = true })
vim.keymap.set('n', '<leader>nh', ':noh<CR>', { silent = true })
-- Esc doesn't clear hlsearch by default; make it do so (without losing the
-- usual "cancel pending count/operator" behavior of Esc in normal mode).
vim.keymap.set('n', '<Esc>', ':noh<CR><Esc>', { silent = true })
vim.keymap.set('n', '<leader>ut', vim.cmd.UndotreeToggle, { silent = true })
