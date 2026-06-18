vim.g.mapleader = ' '

local function neotree_switch_focus()
  if vim.bo.filetype == 'neo-tree' then
    vim.cmd('wincmd p')
  else
    vim.cmd('Neotree focus')
  end
end

vim.keymap.set('n', '<leader>e', '<cmd>Neotree toggle<CR>', { desc = 'NeoTree: Toggle' })
vim.keymap.set('n', '<leader>ww', neotree_switch_focus, { desc = 'NeoTree: Switch Focus' })

vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    if vim.fn.argc() == 0 then
      vim.cmd('Neotree')
    end
  end
})

require("neo-tree").setup({
  window = {
    width = 30
  }
})

vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = function()
    vim.api.nvim_set_hl(0, 'NeoTreeNormal', { link = 'Normal' })
    vim.api.nvim_set_hl(0, 'NeoTreeNormalNC', { link = 'Normal' })
    vim.api.nvim_set_hl(0, 'NeoTreeEndOfBuffer', { link = 'EndOfBuffer' })
    vim.api.nvim_set_hl(0, 'NeoTreeWinSeparator', { link = 'Normal' })
  end
})
