local ok, copilot = pcall(require, 'copilot')
if not ok then
    return
end

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
            -- Wired manually below so we can self-heal stale markers.
            accept = false,
            next = '<M-]>',
            prev = '<M-[>',
            dismiss = '<C-]>',
        },
    },
    -- Next Edit Suggestions (NES) are normal-mode, multi-location edits.
    -- Keep their keys separate from insert-mode <Tab>, which accepts the
    -- ordinary Copilot ghost-text completion above.
    nes = {
        enabled = true,
        auto_trigger = true,
        keymap = {
            accept_and_goto = '<leader>ca',
            accept = false,
            dismiss = '<leader>cx',
        },
    },
})

local suggestion_ns = vim.api.nvim_create_namespace('copilot.suggestion')

-- copilot.lua's own accept checks `suggestion.is_visible()`, which only
-- tests whether a fixed extmark id (1) exists — not whether it's backed by
-- real suggestion content. If the extmark is ever left dangling (cleared
-- logically but the id still present), is_visible() returns a false
-- positive, accept() silently no-ops, and the keypress is swallowed: no
-- suggestion inserted, no literal tab either. Wiring it ourselves lets us
-- detect that stale case — a real accept always moves the cursor — and
-- fall through to a literal tab instead of swallowing the keypress.
vim.keymap.set('i', '<Tab>', function()
    local suggestion = require('copilot.suggestion')
    if not suggestion.is_visible() then
        return '<Tab>'
    end

    local cursor_before = vim.api.nvim_win_get_cursor(0)
    suggestion.accept()
    local cursor_after = vim.api.nvim_win_get_cursor(0)
    if cursor_before[1] == cursor_after[1] and cursor_before[2] == cursor_after[2] then
        -- accept() didn't move the cursor — stale extmark, clear it and
        -- fall through to a literal tab.
        pcall(vim.api.nvim_buf_del_extmark, 0, suggestion_ns, 1)
        return '<Tab>'
    end
    return ''
end, { expr = true, desc = 'Accept Copilot ghost-text suggestion' })
