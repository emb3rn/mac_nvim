local builtin = require('telescope.builtin')
local actions = require('telescope.actions')

vim.keymap.set('n', '<leader><leader>', function()
    -- frecency ranks results by frequency+recency of access, not just sort
    -- order/mtime — so a file you keep reopening (e.g. scout.py) climbs to
    -- the top over time instead of always losing to whatever's alphabetically
    -- or chronologically first. Falls back to plain find_files if the
    -- extension somehow isn't loaded.
    local ok = pcall(require('telescope').extensions.frecency.frecency, { previewer = false })
    if not ok then
        builtin.find_files({ previewer = false })
    end
end, { desc = 'Telescope: Find Files (Frecency)' })

vim.keymap.set('n', '<leader>sg', function()
    builtin.live_grep({
        -- ripgrep treats the query as a regex by default, so an unbalanced
        -- "(" (e.g. typing "if len(") is an invalid regex and rg silently
        -- returns nothing. --fixed-strings makes it a literal search instead.
        additional_args = { '--fixed-strings' },
    })
end, { desc = 'Telescope: Grep (Content Search)' })

vim.keymap.set('n', '<leader>sf', function()
    -- Search actual symbols (functions, classes, ...) via LSP rather than
    -- raw text. Falls back to a fuzzy line search if no LSP client in the
    -- buffer supports document symbols.
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    local has_symbols = false
    for _, client in ipairs(clients) do
        if client:supports_method('textDocument/documentSymbol') then
            has_symbols = true
            break
        end
    end

    if has_symbols then
        builtin.lsp_document_symbols({
            -- Exclude variable/field/constant/property kinds — too noisy.
            -- Telescope only accepts an include-list, so enumerate
            -- everything else.
            symbols = {
                'function', 'method', 'constructor',
                'class', 'interface', 'struct', 'enum', 'enummember',
                'module', 'namespace', 'package',
                'typeparameter', 'event', 'operator',
            },
        })
    else
        builtin.current_buffer_fuzzy_find({ previewer = false })
    end
end, { desc = 'Telescope: Search Symbols In File' })

require('telescope').setup({
    defaults = {
        sorting_strategy = 'ascending',
        prompt_prefix = ' ',
        selection_caret = ' ',
        border = false,
        layout_config = {
            horizontal = {
                prompt_position = 'top',
                preview_width = 0.55,
            },
            width = 0.5,
            height = 0.4,
        },
        -- Recenter the window on the jumped-to line (e.g. after <leader>sf),
        -- instead of leaving it wherever it happened to land on screen.
        mappings = {
            i = { ['<CR>'] = actions.select_default + actions.center },
            n = { ['<CR>'] = actions.select_default + actions.center },
        },
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = 'smart_case',
        },
    },
})

-- fzf-native: space-separated terms are AND-matched anywhere in the result,
-- so "realtime s" will match "realtime_simulation".
pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'frecency')

-- TelescopeMatching (the highlight on matched characters in results) links
-- to the `Search` group by default, which is the same yellow-ish highlight
-- used for hlsearch matches. Give it its own subtle style instead.
local function set_telescope_hl()
    vim.api.nvim_set_hl(0, 'TelescopeMatching', { fg = '#61afef', bold = true })
end

set_telescope_hl()
vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = '*',
    callback = set_telescope_hl,
})
