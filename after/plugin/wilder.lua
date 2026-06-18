local wilder = require('wilder')
wilder.setup({ modes = { ':', '/', '?' } })

wilder.set_option('pipeline', {
    wilder.branch(
        wilder.cmdline_pipeline({ fuzzy = 1 }),
        wilder.search_pipeline()
    ),
})

wilder.set_option('renderer', wilder.popupmenu_renderer(
    wilder.popupmenu_border_theme({
        highlighter = wilder.basic_highlighter(),
        highlights = {
            border = 'Normal',
            default = 'WilderMenu',
            accent = wilder.make_hl('WilderAccent', 'Pmenu', { { a = 1 }, { a = 1 }, { foreground = '#80a0ff' } }),
        },
        border = 'rounded',
        max_height = 8,
    })
))

local function set_wilder_hl()
    vim.api.nvim_set_hl(0, 'WilderMenu', { link = 'Pmenu' })
end

set_wilder_hl()
vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = '*',
    callback = set_wilder_hl,
})
