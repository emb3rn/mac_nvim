-- Neovim's own bundled $VIMRUNTIME/ftplugin/markdown.lua unconditionally
-- calls vim.treesitter.start() — independent of nvim-treesitter's plugin
-- config entirely. Its markdown query hits a Neovim 0.12 bug on fenced
-- code block delimiters (https://github.com/neovim/neovim/issues/39032),
-- crashing the decoration provider. Telescope previews/searches re-render
-- whatever buffer is matched, which is what was triggering this on any
-- .md file. after/ftplugin/ is the documented way to override a builtin
-- ftplugin's effects, and runs after it.
vim.treesitter.stop()
