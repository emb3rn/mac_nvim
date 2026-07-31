-- Override StatusLine highlight to be transparent (runs before lualine setup)
local function set_statusline_hl()
    vim.api.nvim_set_hl(0, 'StatusLine', { bg = 'NONE', fg = '#a7aab0' })
    vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = 'NONE', fg = '#6e7681' })
end

set_statusline_hl()
vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = '*',
    group = vim.api.nvim_create_augroup('user_lualine_colors', { clear = true }),
    callback = set_statusline_hl,
})

-- Every mode shares the same b/c/x/y/z color, only the `a` (mode indicator)
-- section's foreground changes.
local fg = '#a7aab0'
local function mode(a_fg, rest_fg)
    rest_fg = rest_fg or fg
    local section = { bg = 'NONE', fg = rest_fg }
    return { a = { bg = 'NONE', fg = a_fg }, b = section, c = section, x = section, y = section, z = section }
end

local ok, lualine = pcall(require, 'lualine')
if not ok then return end

lualine.setup({
    options = {
        icons_enabled = true,
        theme = {
            normal = mode(fg),
            insert = mode('#8aff8a'),
            visual = mode('#ffcc00'),
            replace = mode('#ff8a8a'),
            command = mode('#8a8aff'),
            inactive = mode('#6e7681', '#6e7681'),
        },
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = { statusline = {}, winbar = {} },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = { statusline = 1000, tabline = 1000, winbar = 1000 },
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {},
})
