require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "python" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  auto_install = true,

  highlight = {
    enable = true,
    disable = { "c", "rust" },
    additional_vim_regex_highlighting = false,
  },

  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
  },
}

-- Enable treesitter folding (uses Neovim's built-in treesitter foldexpr,
-- since nvim-treesitter's own `nvim_treesitter#foldexpr()` is buggy/deprecated
-- in favor of `vim.treesitter.foldexpr()`)
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99 -- Open all folds by default

-- Fold keymaps
vim.keymap.set("n", "<leader>fa", "zM", { desc = "Fold all", silent = true })
vim.keymap.set("n", "<leader>ua", "zR", { desc = "Unfold all", silent = true })
vim.keymap.set("n", "<leader>fd", "za", { desc = "Toggle fold under cursor", silent = true })
