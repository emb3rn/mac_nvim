local ok, harpoon = pcall(require, 'harpoon')
if not ok then return end

harpoon:setup()

vim.keymap.set('n', '<leader>a', function() harpoon:list():add() end)
vim.keymap.set('n', '<leader>h', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set('n', '<leader>1', function() harpoon:list():select(1) end)
vim.keymap.set('n', '<leader>2', function() harpoon:list():select(2) end)
vim.keymap.set('n', '<leader>3', function() harpoon:list():select(3) end)
vim.keymap.set('n', '<leader>4', function() harpoon:list():select(4) end)

-- Ensure NormalFloat and FloatBorder inherit from Normal for a consistent
-- background across all floating windows (not just Harpoon's).
local function set_float_hl()
    vim.api.nvim_set_hl(0, 'NormalFloat', { link = 'Normal' })
    vim.api.nvim_set_hl(0, 'FloatBorder', { link = 'Normal' })
end

set_float_hl()
vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = '*',
    group = vim.api.nvim_create_augroup('user_harpoon_colors', { clear = true }),
    callback = set_float_hl,
})
