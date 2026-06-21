local ok, sidekick = pcall(require, 'sidekick')
if not ok then
    return
end

-- Ensure copilot LSP is enabled, since sidekick relies on it. nvim-lspconfig
-- ships a default `copilot` server config (cmd = copilot-language-server),
-- installed via Mason — this is the same client lsp.lua wires ghost-text
-- completions through, so there's only one Copilot connection total.
vim.lsp.enable('copilot')

sidekick.setup({
    nes = {
        diff = {
            inline = 'words', -- "chars", "words", or "lines"
        },
        enabled = true,
    },
    cli = {
        mux = {
            backend = 'tmux', -- or "zellij" for session persistence
            enabled = true,
        },
    },
})

-- <Tab> does whichever Copilot suggestion is showing: ghost-text completion
-- first (the common case while typing), then NES jump/apply, else a literal
-- tab. Matches the single-key muscle memory copilot.vim used to provide.
vim.keymap.set({ 'n', 'i' }, '<Tab>', function()
    if vim.lsp.inline_completion.get() then
        return ''
    end
    return require('sidekick').nes_jump_or_apply() and '' or '<Tab>'
end, { expr = true, desc = 'Accept completion / NES Jump/Apply' })

vim.keymap.set('n', '<leader>aa', function()
    require('sidekick.cli').toggle()
end, { desc = 'Toggle CLI' })

vim.keymap.set('n', '<leader>as', function()
    require('sidekick.cli').select()
end, { desc = 'Select Tool' })

vim.keymap.set({ 'n', 'x' }, '<leader>ap', function()
    require('sidekick.cli').prompt()
end, { desc = 'Send Prompt' })
