require('github-theme').setup({})

-- Align nvim-treesitter highlighting with VS Code's "GitHub Dark Default"
-- theme for Python, since github-theme.nvim's own treesitter mappings drift
-- from what VS Code's TextMate grammar (+ Pylance semantic tokens) actually
-- renders. Each line below was checked against the real MagicPython grammar
-- scopes and github-vscode-theme's tokenColors rules:
--   * @variable.parameter / @type.builtin: plain white/blue here, but VS
--     Code's "variable"/builtin-type scopes render in GitHub's orange.
--   * @constant (ALL_CAPS heuristic): VS Code doesn't special-case ALL_CAPS
--     Python names, they're plain variables.
--   * @keyword.exception (try/except/finally/raise): shares the same
--     keyword.control.flow scope as every other keyword, so it must match
--     @keyword (red), not blue.
--   * @operator: every Python operator is scoped keyword.operator.*, which
--     is still just `keyword` → red, not the classic blue `Operator` group.
--   * @attribute / @attribute.builtin (decorators): plain decorator names
--     share entity.name.function with regular functions (purple); only
--     classmethod/property/staticmethod get the builtin-type scope
--     (orange).
--   * @module (bare import name): no special grammar scope, so plain
--     foreground text, not keyword-red.
--   * @function.builtin (print, len, ...): renders the same purple as
--     user-defined functions, confirmed empirically.
--   * @variable.builtin (self/cls — the only identifiers treesitter tags
--     this way in Python): plain white, not the blue used for actual
--     language builtins.
local function set_github_python_hl()
    if not (vim.g.colors_name or ''):match('^github') then
        return
    end
    vim.api.nvim_set_hl(0, '@variable.parameter', { fg = '#ffa657' })
    vim.api.nvim_set_hl(0, '@type.builtin.python', { fg = '#ffa657' })
    vim.api.nvim_set_hl(0, '@constant.python', { link = '@variable' })
    vim.api.nvim_set_hl(0, '@keyword.exception.python', { link = '@keyword' })
    vim.api.nvim_set_hl(0, '@operator.python', { fg = '#ff7b72' })
    vim.api.nvim_set_hl(0, '@attribute.python', { fg = '#d2a8ff' })
    vim.api.nvim_set_hl(0, '@attribute.builtin.python', { fg = '#ffa657' })
    vim.api.nvim_set_hl(0, '@module.python', { link = '@variable' })
    vim.api.nvim_set_hl(0, '@function.builtin.python', { link = '@function' })
    vim.api.nvim_set_hl(0, '@variable.builtin.python', { fg = '#e6edf3' })

    -- github-theme's own CursorLine background is too close to Normal's to
    -- read at a glance; give it a clearly distinct (but still subtle) shade.
    vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#21262d' })
end

set_github_python_hl()
vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = '*',
    group = vim.api.nvim_create_augroup('user_github_theme_colors', { clear = true }),
    callback = set_github_python_hl,
})
