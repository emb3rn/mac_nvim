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
