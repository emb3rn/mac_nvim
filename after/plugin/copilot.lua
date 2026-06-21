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
        keymap = {
            accept = '<Tab>',
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
