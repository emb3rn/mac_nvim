require('bufferline').setup({
    options = {
        mode = 'buffers',
        separator_style = { '', '' },
        always_show_bufferline = true,
        diagnostics = 'nvim_lsp',
        close_icon = '',
        left_trunc_marker = '',
        right_trunc_marker = '',
        tab_size = 18,
        max_name_length = 18,
        color_icons = true,
        offsets = {
            { filetype = 'neo-tree', text = 'File Explorer', text_align = 'center', separator = false },
        },
    },
})
