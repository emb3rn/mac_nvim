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
        enabled = true,
        diff = {
            -- inline = "words"/"chars" overlays the proposed change directly
            -- on top of the line being edited, which made it unreadable
            -- while typing. `false` switches to whole-line diffing instead:
            -- the original line gets a red background in place, and the
            -- proposed change renders as a separate green virtual line
            -- below it — the VS Code NES style, nothing overlapping.
            inline = false,
        },
    },
    cli = {
        mux = {
            backend = 'tmux', -- or "zellij" for session persistence
            enabled = true,
        },
    },
})

-- By default SidekickDiffDelete/Add/Context link to DiffDelete/DiffText/
-- DiffChange, and DiffText (used for the proposed addition) renders orange
-- in this theme — confusing next to the red deletion. Override explicitly:
-- red for the current/old line, green for the proposed new one, and a
-- neutral background for surrounding context so only the actual change
-- stands out.
local function set_sidekick_hl()
    vim.api.nvim_set_hl(0, 'SidekickDiffDelete', { bg = '#3b1219' })
    vim.api.nvim_set_hl(0, 'SidekickDiffAdd', { bg = '#0f3d1e' })
    -- `bg = 'NONE'` alone produces an empty highlight table, which Neovim
    -- still treats as "unset" and lets sidekick's own default link win — an
    -- explicit link to Normal is a real definition that actually sticks.
    vim.api.nvim_set_hl(0, 'SidekickDiffContext', { link = 'Normal' })
end

set_sidekick_hl()
vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = '*',
    callback = set_sidekick_hl,
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
