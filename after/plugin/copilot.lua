local ok, copilot = pcall(require, 'copilot')
if not ok then
    return
end

-- Debounce (ms) between edits and copilot-lsp's next-edit request. Must be
-- set before copilot.setup() runs; the equivalent packer `requires` `init`
-- hook doesn't fire for nested dependency specs, so it's set here instead.
vim.g.copilot_nes_debounce = 500

-- Ghost-text completions (suggestion) and Next Edit Suggestions (nes) in one
-- package. GitHub's own docs call the NES half "experimental, may not work
-- as expected" — if it turns out as unreliable as sidekick's NES did, the
-- fix is just `nes.enabled = false` below; ghost-text is unaffected by that.
copilot.setup({
    suggestion = {
        enabled = true,
        auto_trigger = true,
        -- Default true: hides the ghost-text suggestion whenever nvim-cmp's
        -- popup is visible, which is most of the time while typing real
        -- code — meaning <Tab> just inserted a literal tab since there was
        -- never anything showing to accept.
        hide_during_completion = false,
        -- Default true: lets <Tab> double as "request a suggestion" when
        -- none is visible yet, swallowing the keypress (no tab inserted,
        -- nothing else happens either) instead of falling through to a
        -- literal tab. Redundant anyway since auto_trigger already fetches
        -- suggestions as you type — <Tab> should only ever accept one.
        trigger_on_accept = false,
        keymap = {
            -- accept is wired manually below instead of `<Tab>` here — see
            -- that comment for why.
            accept = false,
            next = '<M-]>',
            prev = '<M-[>',
            dismiss = '<C-]>',
        },
    },
    nes = {
        enabled = true,
        keymap = {
            -- Kept off <Tab> deliberately so it can never shadow the
            -- ghost-text accept above.
            accept_and_goto = '<leader>cn',
            accept = false,
            dismiss = '<Esc>',
        },
    },
})

local suggestion_ns = vim.api.nvim_create_namespace('copilot.suggestion')

-- For multi-line suggestions, copilot.lua renders the current line's
-- portion as virt_text and any further suggested lines as virt_lines below
-- it. The indentation of that first further line is the suggestion's "real"
-- indent — read directly off the extmark, no private suggestion internals
-- needed.
---@return string? leading whitespace of the suggestion's next new line, or
---nil if the suggestion is single-line (no indent-mismatch concept applies)
local function suggestion_next_line_indent()
    local ok, extmark =
        pcall(vim.api.nvim_buf_get_extmark_by_id, 0, suggestion_ns, 1, { details = true })
    if not ok or not extmark[3] or not extmark[3].virt_lines or #extmark[3].virt_lines == 0 then
        return nil
    end
    local first_chunk = extmark[3].virt_lines[1][1]
    local text = first_chunk and first_chunk[1] or ''
    return text:match('^%s*')
end

-- copilot.lua's own <Tab>-accept checks `suggestion.is_visible()`, which
-- just checks whether a fixed extmark id exists — not whether it's backed
-- by real, current suggestion text. If that extmark is ever left dangling
-- (cleared logically but not visually, e.g. after a buffer edit shifts
-- things around), is_visible() returns a false positive, accept() silently
-- no-ops, and <Tab> does nothing at all: no suggestion inserted, no literal
-- tab either. Wiring it ourselves lets us detect that case directly — a
-- real accept always moves the cursor — and self-heal by clearing the
-- stale marker and falling through to a literal tab instead of swallowing
-- the keypress.
--
-- Also: only accept a multi-line suggestion once the cursor's own
-- indentation matches the indent of its next suggested line. Otherwise
-- <Tab> just indents normally (which naturally walks you toward a match)
-- instead of jumping you straight to a deeper indent than you're at.
vim.keymap.set('i', '<Tab>', function()
    local suggestion = require('copilot.suggestion')
    if not suggestion.is_visible() then
        return '<Tab>'
    end

    local next_indent = suggestion_next_line_indent()
    if next_indent then
        local current_indent = vim.api.nvim_get_current_line():match('^%s*')
        if next_indent ~= current_indent then
            return '<Tab>'
        end
    end

    local cursor_before = vim.api.nvim_win_get_cursor(0)
    suggestion.accept()
    local cursor_after = vim.api.nvim_win_get_cursor(0)
    if cursor_before[1] == cursor_after[1] and cursor_before[2] == cursor_after[2] then
        pcall(vim.api.nvim_buf_del_extmark, 0, suggestion_ns, 1)
        return '<Tab>'
    end
    return ''
end, { expr = true, desc = 'Accept completion (self-healing, indent-gated)' })

-- copilot-lsp requests a fresh NES suggestion on every TextChangedI (i.e.
-- while actively typing), which is exactly the red/green popup-while-typing
-- behavior that's distracting. `lsp_on_init` reads `nes.request_nes` fresh
-- each time it fires (not a cached reference captured at load time), so
-- patching the field here — well before the async LSP handshake that calls
-- lsp_on_init completes — reliably takes effect. Block requests while in
-- insert/replace mode, then fire one explicitly on InsertLeave so a
-- suggestion is ready right when you're back in normal mode instead of
-- popping up mid-edit.
local nes_ok, nes = pcall(require, 'copilot-lsp.nes')
if nes_ok then
    local request_nes = nes.request_nes
    nes.request_nes = function(...)
        if vim.fn.mode():match('^[iR]') then
            return
        end
        return request_nes(...)
    end

    vim.api.nvim_create_autocmd('InsertEnter', {
        callback = function()
            nes.clear()
        end,
        desc = 'Hide any NES suggestion while typing',
    })

    vim.api.nvim_create_autocmd('InsertLeave', {
        callback = function()
            local client = vim.lsp.get_clients({ name = 'copilot' })[1]
            if client then
                nes.request_nes(client)
            end
        end,
        desc = 'Request a fresh NES suggestion once back in normal mode',
    })
end
