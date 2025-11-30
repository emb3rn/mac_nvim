local harpoon = require("harpoon")

harpoon:setup()

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end)

-- Ensure NormalFloat is transparent for all floating windows
local function set_float_hl()
  vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none', ctermbg = 'none' })
  vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none', ctermbg = 'none' })
end

set_float_hl() -- Set immediately
vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = set_float_hl,
})
