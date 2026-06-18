--setup github theme
require('github-theme').setup({})

-- Align nvim-treesitter highlighting with VS Code's "GitHub Dark Default"
-- theme for Python. github-theme.nvim's own treesitter mappings drift from
-- what VS Code's TextMate grammar actually renders:
--   * @variable.parameter uses plain white (spec.fg1) here, but VS Code's
--     "variable" scope (used for parameters) is GitHub's orange (#ffa657).
--   * @type.builtin.python is explicitly linked to '@constant' (blue) here,
--     but VS Code renders builtin types in that same orange.
--   * @constant.python (treesitter's ALL_CAPS-identifier heuristic) inherits
--     plain 'Constant' (blue), but VS Code doesn't special-case ALL_CAPS
--     names in Python — they render as plain variables.
--
-- Second pass, found by tracing the actual MagicPython TextMate grammar
-- scopes against github-vscode-theme's tokenColors rules:
--   * try/except/finally/raise all get the same `keyword.control.flow`
--     scope as every other keyword, so @keyword.exception (blue here) must
--     match @keyword (red).
--   * Every Python operator (+, ==, and, or, ...) is scoped
--     `keyword.operator.*`, which is still just `keyword` → red. @operator
--     here resolves to the classic blue `Operator` group — wrong.
--   * Decorator names get `entity.name.function.decorator`, the same scope
--     as plain function names (purple) — except classmethod/property/
--     staticmethod, which the grammar special-cases as `support.type`
--     (the builtin-type scope, orange). @attribute (white) and
--     @attribute.builtin (also wrong) need to swap to purple/orange.
--   * A bare module name in `import os` has no special scope, so it's
--     plain foreground text, not the keyword-red @module currently shows.
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
  -- Builtin calls (print, len, ...) render the same purple as user-defined
  -- functions in VS Code — confirmed empirically (the `support.function`
  -- defaultLibrary-modifier derivation that suggested blue was wrong).
  vim.api.nvim_set_hl(0, '@function.builtin.python', { link = '@function' })
  -- `self`/`cls` are the only identifiers treesitter tags @variable.builtin
  -- in Python; VS Code renders them as plain parameters/variables (white),
  -- not the blue used for actual language builtins.
  vim.api.nvim_set_hl(0, '@variable.builtin.python', { fg = '#e6edf3' })
end

set_github_python_hl()
vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = set_github_python_hl,
})
