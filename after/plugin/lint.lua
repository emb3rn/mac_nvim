local ok, lint = pcall(require, 'lint')
if not ok then
    return
end

lint.linters_by_ft = {
    lua = { 'luacheck' },
}

lint.linters.luacheck.args = {
    '--formatter', 'plain',
    '--codes',
    '--std', 'nvim',
    '--globals', 'vim',
    '--select', 'W601', -- trailing whitespace
    '--no-color',
}

vim.api.nvim_create_autocmd('BufWritePost', {
    callback = function()
        lint.try_lint()
    end,
})
