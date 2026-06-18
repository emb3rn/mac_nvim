local ok, sidekick = pcall(require, 'sidekick')
if not ok then
    return
end

-- Ensure copilot LSP is enabled, since sidekick relies on it
vim.lsp.enable('copilot', {
    cmd = { 'copilot-language-server', '--stdio' },
    settings = {
        ['github-copilot'] = {
            suggestion = { enabled = true },
        },
    },
})

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

vim.keymap.set({ 'n', 'i' }, '<Tab>', function()
    return require('sidekick').nes_jump_or_apply() and '' or '<Tab>'
end, { expr = true, desc = 'NES Jump/Apply' })

vim.keymap.set('n', '<leader>aa', function()
    require('sidekick.cli').toggle()
end, { desc = 'Toggle CLI' })

vim.keymap.set('n', '<leader>as', function()
    require('sidekick.cli').select()
end, { desc = 'Select Tool' })

vim.keymap.set({ 'n', 'x' }, '<leader>ap', function()
    require('sidekick.cli').prompt()
end, { desc = 'Send Prompt' })
