local builtin = require('telescope.builtin')
local actions = require('telescope.actions')

local function filename_only(_, path)
    return vim.fn.fnamemodify(path, ':t')
end

-- Caps a displayed path to at most `depth` trailing components, e.g.
-- "polybot/modules/scout/realtime.py" with depth=3 -> "scout/realtime.py".
---@param path string
---@param depth integer
local function cap_path_depth(path, depth)
    local parts = vim.split(path, '/', { plain = true })
    if #parts <= depth then
        return path
    end
    return table.concat(vim.list_slice(parts, #parts - depth + 1), '/')
end

vim.keymap.set('n', '<leader><leader>', function()
    -- frecency ranks results by frequency+recency of access, not just sort
    -- order/mtime — so a file you keep reopening (e.g. scout.py) climbs to
    -- the top over time instead of always losing to whatever's alphabetically
    -- or chronologically first. Falls back to plain find_files if the
    -- extension somehow isn't loaded.
    local opts = {
        previewer = false,
        -- Include every file under the current project while still ranking
        -- files that have been visited more often or more recently first.
        workspace = 'CWD',
        -- Full path is rarely useful here, just enough to disambiguate
        -- same-named files in different dirs — cap at 3 components deep.
        path_display = function(_, path)
            return cap_path_depth(path, 3)
        end,
    }
    local ok = pcall(require('telescope').extensions.frecency.frecency, opts)
    if not ok then
        builtin.find_files(opts)
    end
end, { desc = 'Telescope: Find Files (Frecency)' })

vim.keymap.set('n', '<leader>sg', function()
    builtin.live_grep({
        -- ripgrep treats the query as a regex by default, so an unbalanced
        -- "(" (e.g. typing "if len(") is an invalid regex and rg silently
        -- returns nothing. --fixed-strings makes it a literal search instead.
        additional_args = { '--fixed-strings' },
        -- Default display is "relative/path/to/file.py:line: text" — drop
        -- the path entirely and show just the filename, since which exact
        -- directory a match is in is rarely what you're scanning results for.
        entry_maker = function(line)
            local make_entry = require('telescope.make_entry').gen_from_vimgrep({})
            local entry = make_entry(line)
            if not entry then
                return entry
            end
            entry.display = function(e)
                -- e.text is the raw matched line, indentation and all — strip
                -- the leading whitespace so results aren't padded out wide
                -- enough to push the actual match off the edge of the window.
                local text = (e.text or ''):gsub('^%s+', '')
                return vim.fn.fnamemodify(e.filename, ':t') .. ':' .. e.lnum .. ': ' .. text
            end
            return entry
        end,
    })
end, { desc = 'Telescope: Grep (Content Search)' })

-- Exclude variable/field/constant/property kinds — too noisy. Telescope
-- only accepts an include-list, so enumerate everything else. Shared
-- between the current-file and workspace-wide symbol searches below.
local symbol_kinds = {
    'function', 'method', 'constructor',
    'class', 'interface', 'struct', 'enum', 'enummember',
    'module', 'namespace', 'package',
    'typeparameter', 'event', 'operator',
}

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
        builtin.lsp_document_symbols({ symbols = symbol_kinds })
    else
        builtin.current_buffer_fuzzy_find({ previewer = false })
    end
end, { desc = 'Telescope: Search Symbols In File' })

vim.keymap.set('n', '<leader>af', function()
    -- Same symbol search as <leader>sf, but across the whole workspace
    -- instead of just the current file. Dynamic (re-queries the LSP server
    -- per keystroke) rather than the static lsp_workspace_symbols, which
    -- only queries once up front with an empty filter.
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    local has_symbols = false
    for _, client in ipairs(clients) do
        if client:supports_method('workspace/symbol') then
            has_symbols = true
            break
        end
    end

    if not has_symbols then
        vim.notify('No LSP server attached supports workspace symbols', vim.log.levels.WARN)
        return
    end

    builtin.lsp_dynamic_workspace_symbols({
        symbols = symbol_kinds,
        -- Same reasoning as <leader>sg: which directory a symbol lives in is
        -- rarely useful here, just the filename to disambiguate.
        path_display = filename_only,
    })
end, { desc = 'Telescope: Search Functions/Symbols (Workspace)' })

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
            width = 0.85,
            height = 0.8,
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
        frecency = {
            -- db_safe_mode (default true) prompts on every startup to
            -- confirm pruning stale entries (deleted/moved files) from the
            -- frecency db — just let it clean those up silently instead.
            db_safe_mode = false,
            -- Search with fuzzy matching rather than the extension's exact
            -- matcher, while keeping recently visited files ranked first.
            matcher = 'fuzzy',
            workspace_scan_cmd = { 'rg', '-.g', '!.git', '--files' },
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
    group = vim.api.nvim_create_augroup('user_telescope_colors', { clear = true }),
    callback = set_telescope_hl,
})
