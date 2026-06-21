local ok, copilot = pcall(require, 'copilot')
if not ok then
    return
end

-- Ghost-text completions (suggestion) and Next Edit Suggestions (nes) in one
-- package. GitHub's own docs call the NES half "experimental, may not work
-- as expected" — if it turns out as unreliable as sidekick's NES did, the
-- fix is just `nes.enabled = false` below; ghost-text is unaffected by that.
copilot.setup({
    suggestion = {
        enabled = true,
        auto_trigger = true,
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
