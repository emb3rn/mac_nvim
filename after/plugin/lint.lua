local lint = require('lint')

lint.linters_by_ft = {
  lua = { 'luacheck' },
}

lint.linters.luacheck.args = {
  '--formatter', 'plain',
  '--codes',
  '--std', 'nvim',
  '--globals', 'vim',
  '--select', 'W601', -- W601 is the code for trailing whitespace in luacheck
  '--no-color',
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    lint.try_lint()
  end,
})
