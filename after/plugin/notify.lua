local ok, notify = pcall(require, 'notify')
if not ok then return end

notify.setup({
    stages = 'fade',
    timeout = 1000,
    max_height = 5,
    max_width = 70,
    background_colour = 'NotifyBackground',
    render = 'minimal',
})
