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
  end,
})

local ok, neo_tree = pcall(require, 'neo-tree')
if not ok then return end

neo_tree.setup({
  close_if_last_window = false,
  popup_border_style = 'rounded',
  enable_git_status = true,
  enable_diagnostics = true,
  window = {
    position = 'left',
    width = 30,
  },
  filesystem = {
    filtered_items = {
      visible = true,
      hide_dotfiles = false,
      hide_gitignored = false,
    },
  },
})

vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  group = vim.api.nvim_create_augroup('user_neotree_colors', { clear = true }),
  callback = function()
    vim.api.nvim_set_hl(0, 'NeoTreeNormal', { link = 'Normal' })
    vim.api.nvim_set_hl(0, 'NeoTreeNormalNC', { link = 'Normal' })
    vim.api.nvim_set_hl(0, 'NeoTreeEndOfBuffer', { link = 'EndOfBuffer' })
    vim.api.nvim_set_hl(0, 'NeoTreeWinSeparator', { link = 'Normal' })
  end,
})
