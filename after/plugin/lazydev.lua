local status, lazydev = pcall(require, "lazydev")
if not status then
    return
end

lazydev.setup({
    library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
    },
})
