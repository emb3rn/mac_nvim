-- Override StatusLine highlight to be transparent (runs before lualine setup)
local function set_statusline_hl()
  vim.api.nvim_set_hl(0, 'StatusLine', { bg = 'NONE', fg = '#a7aab0' })
  vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = 'NONE', fg = '#6e7681' })
end

set_statusline_hl()
vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = set_statusline_hl,
})

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = {
      normal = { a = { bg = 'NONE', fg = '#a7aab0' }, b = { bg = 'NONE', fg = '#a7aab0' }, c = { bg = 'NONE', fg = '#a7aab0' }, x = { bg = 'NONE', fg = '#a7aab0' }, y = { bg = 'NONE', fg = '#a7aab0' }, z = { bg = 'NONE', fg = '#a7aab0' } },
      insert = { a = { bg = 'NONE', fg = '#8aff8a' }, b = { bg = 'NONE', fg = '#a7aab0' }, c = { bg = 'NONE', fg = '#a7aab0' }, x = { bg = 'NONE', fg = '#a7aab0' }, y = { bg = 'NONE', fg = '#a7aab0' }, z = { bg = 'NONE', fg = '#a7aab0' } },
      visual = { a = { bg = 'NONE', fg = '#ffcc00' }, b = { bg = 'NONE', fg = '#a7aab0' }, c = { bg = 'NONE', fg = '#a7aab0' }, x = { bg = 'NONE', fg = '#a7aab0' }, y = { bg = 'NONE', fg = '#a7aab0' }, z = { bg = 'NONE', fg = '#a7aab0' } },
      replace = { a = { bg = 'NONE', fg = '#ff8a8a' }, b = { bg = 'NONE', fg = '#a7aab0' }, c = { bg = 'NONE', fg = '#a7aab0' }, x = { bg = 'NONE', fg = '#a7aab0' }, y = { bg = 'NONE', fg = '#a7aab0' }, z = { bg = 'NONE', fg = '#a7aab0' } },
      command = { a = { bg = 'NONE', fg = '#8a8aff' }, b = { bg = 'NONE', fg = '#a7aab0' }, c = { bg = 'NONE', fg = '#a7aab0' }, x = { bg = 'NONE', fg = '#a7aab0' }, y = { bg = 'NONE', fg = '#a7aab0' }, z = { bg = 'NONE', fg = '#a7aab0' } },
      inactive = { a = { bg = 'NONE', fg = '#6e7681' }, b = { bg = 'NONE', fg = '#6e7681' }, c = { bg = 'NONE', fg = '#6e7681' }, x = { bg = 'NONE', fg = '#6e7681' }, y = { bg = 'NONE', fg = '#6e7681' }, z = { bg = 'NONE', fg = '#6e7681' } },
    },
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
