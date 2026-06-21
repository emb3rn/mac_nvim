vim.keymap.set('n', 'gl', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        local opts = { buffer = event.buf }

        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        -- Override builtin `gd` (text-search "local declaration", stays in
        -- the current file) with the real LSP definition request, which
        -- jumps across files.
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gi', function()
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            if #clients == 0 then
                vim.notify('No LSP server attached to this buffer', vim.log.levels.WARN)
                return
            end
            for _, client in ipairs(clients) do
                if client:supports_method('textDocument/implementation') then
                    vim.lsp.buf.implementation()
                    return
                end
            end
            -- Pyright (the open-source server) never implemented
            -- textDocument/implementation — that was kept Pylance-exclusive
            -- — so there's no server here to ask. Definition is the closest
            -- useful fallback in Python, which has no real interface/vtable
            -- dispatch.
            vim.lsp.buf.definition()
        end, opts)
        vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, opts)

        -- Telescope's references picker previews the destination live as
        -- you move the selection, unlike the default quickfix list (which
        -- only jumps on <CR>).
        local function references_picker()
            local ok, builtin = pcall(require, 'telescope.builtin')
            if ok then
                builtin.lsp_references()
            else
                vim.lsp.buf.references()
            end
        end
        vim.keymap.set('n', '<leader>gr', references_picker, opts)

        vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'x' }, '<F3>', function() vim.lsp.buf.format({ async = true }) end, opts)
        vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action, opts)

        -- Copilot's ghost-text completions, via the same LSP client sidekick
        -- uses for Next Edit Suggestions (one Copilot connection, not two).
        -- Accepting them is wired into <Tab> in sidekick.lua, alongside NES.
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method('textDocument/inlineCompletion') then
            vim.lsp.inline_completion.enable(true, { bufnr = event.buf })
            vim.keymap.set('i', '<C-g>', vim.lsp.inline_completion.select, opts)
        end
    end,
})

vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '▎',
            [vim.diagnostic.severity.WARN] = '▎',
            [vim.diagnostic.severity.INFO] = '▎',
            [vim.diagnostic.severity.HINT] = '▎',
        },
    },
})

local cmp = require('cmp')
local lspkind = require('lspkind')
cmp.setup({
    sources = {
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },
    },
    window = {
        completion = {
            winhighlight = 'Normal:CmpPmenu,FloatBorder:CmpPmenuBorder,CursorLine:PmenuSel,Search:None',
            width = 0.4, -- 40% of editor width
            col_offset = 3,
        },
        documentation = false, -- no side popup with the item's docstring/signature
    },
    formatting = {
        format = lspkind.cmp_format({
            mode = 'symbol_text', -- icon + kind name, e.g. " Function"
            maxwidth = 50,
        }),
    },
    mapping = {
        ['<Enter>'] = cmp.mapping.confirm({ select = false }),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<C-m>'] = cmp.mapping.select_prev_item({ behavior = 'select' }),
        ['<C-n>'] = cmp.mapping.select_next_item({ behavior = 'select' }),
        ['<C-k>'] = cmp.mapping(function()
            if cmp.visible() then
                cmp.select_prev_item({ behavior = 'insert' })
            else
                cmp.complete()
            end
        end),
        ['<C-j>'] = cmp.mapping(function()
            if cmp.visible() then
                cmp.select_next_item({ behavior = 'insert' })
            else
                cmp.complete()
            end
        end),
    },
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    performance = {
        max_view_entries = 8,
    },
    completion = {
        completeopt = 'menu,menuone,noinsert',
    },
})

-- NOTE: mason-lspconfig v2 (Neovim 0.11+) dropped the old `handlers` option
-- in favor of `vim.lsp.config()` + automatic `vim.lsp.enable()`. See
-- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guide/integrate-with-mason-nvim.md
require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = { 'clangd', 'rust_analyzer', 'pyright', 'ruff', 'copilot' },
    -- automatic_enable defaults to true: every Mason-installed server is
    -- started automatically via vim.lsp.enable(), picking up the
    -- vim.lsp.config() overrides defined below.
})

-- Pyright: relaxed type-checking severity (see `gi` above for why
-- implementation lookups intentionally fall back to definition instead of
-- being forced here — Pyright's open-source server doesn't implement
-- textDocument/implementation at all).
vim.lsp.config('pyright', {
    settings = {
        python = {
            analysis = {
                typeCheckingMode = 'basic', -- "off" = no strict errors; "basic" = light checking
                diagnosticSeverityOverrides = {
                    reportAttributeAccessIssue = 'none',
                    reportOptionalMemberAccess = 'none',
                    reportOptionalOperand = 'none',
                    reportGeneralTypeIssues = 'none',
                },
            },
        },
    },
})

-- Copilot reads its settings via `workspace/configuration` with dotted
-- sections (e.g. "github.copilot"), which Neovim resolves by walking nested
-- keys in `settings` (`settings.github.copilot`) — so it must be nested like
-- this, not a flat `['github.copilot']` key, or the server gets `vim.NIL`
-- and silently treats Next Edit Suggestions as unconfigured/disabled.
vim.lsp.config('copilot', {
    settings = {
        github = {
            copilot = {
                nextEditSuggestions = {
                    enabled = true,
                },
            },
        },
    },
})

-- ruff: disable hover in favor of Pyright
vim.lsp.config('ruff', {
    on_attach = function(client, _bufnr)
        client.server_capabilities.hoverProvider = false
    end,
})

-- Ensure selected CMP item is visible and menu uses default opaque background
local function set_cmp_hl()
    vim.api.nvim_set_hl(0, 'CmpPmenuSel', { fg = 'white', bg = '#313740' })
    vim.api.nvim_set_hl(0, 'CmpPmenu', { link = 'Normal' })
end

set_cmp_hl()
vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = '*',
    callback = set_cmp_hl,
})
