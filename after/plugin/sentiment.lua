-- sentiment.nvim's own setup() isn't idempotent: its internal VimLeavePre
-- "cleaner" autocmd has no re-create guard (unlike its renderer autocmd,
-- which does check), so calling setup() a second time in the same session
-- (e.g. on :ReloadConfig) throws. Only run it once per session.
if not vim.g.loaded_sentiment then
    local ok, sentiment = pcall(require, 'sentiment')
    if not ok then return end
    vim.g.loaded_sentiment = true
    sentiment.setup({
        included_buftypes = {
            [''] = true,
            ['nofile'] = true,
        },
    })
end
