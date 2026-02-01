require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = {
      -- Custom transparent theme
      normal = {
        a = { fg = '#ffffff', bg = 'NONE' },
        b = { fg = '#ffffff', bg = 'NONE' },
        c = { fg = '#ffffff', bg = 'NONE' },
        x = { fg = '#ffffff', bg = 'NONE' },
        y = { fg = '#ffffff', bg = 'NONE' },
        z = { fg = '#ffffff', bg = 'NONE' },
      },
      insert = {
        a = { fg = '#8aff8a', bg = 'NONE' },
        b = { fg = '#ffffff', bg = 'NONE' },
        c = { fg = '#ffffff', bg = 'NONE' },
        x = { fg = '#ffffff', bg = 'NONE' },
        y = { fg = '#ffffff', bg = 'NONE' },
        z = { fg = '#ffffff', bg = 'NONE' },
      },
      visual = {
        a = { fg = '#ffcc00', bg = 'NONE' },
        b = { fg = '#ffffff', bg = 'NONE' },
        c = { fg = '#ffffff', bg = 'NONE' },
        x = { fg = '#ffffff', bg = 'NONE' },
        y = { fg = '#ffffff', bg = 'NONE' },
        z = { fg = '#ffffff', bg = 'NONE' },
      },
      replace = {
        a = { fg = '#ff8a8a', bg = 'NONE' },
        b = { fg = '#ffffff', bg = 'NONE' },
        c = { fg = '#ffffff', bg = 'NONE' },
        x = { fg = '#ffffff', bg = 'NONE' },
        y = { fg = '#ffffff', bg = 'NONE' },
        z = { fg = '#ffffff', bg = 'NONE' },
      },
      command = {
        a = { fg = '#8a8aff', bg = 'NONE' },
        b = { fg = '#ffffff', bg = 'NONE' },
        c = { fg = '#ffffff', bg = 'NONE' },
        x = { fg = '#ffffff', bg = 'NONE' },
        y = { fg = '#ffffff', bg = 'NONE' },
        z = { fg = '#ffffff', bg = 'NONE' },
      },
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