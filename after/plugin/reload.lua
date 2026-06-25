-- `:source $MYVIMRC` alone isn't enough here: init.lua's `require('plugins')`
-- / `require('remap')` are cached in package.loaded after the first load, so
-- re-sourcing init.lua just returns the stale cached module instead of
-- re-running the edited file. Drop them from the cache first so the
-- requires below actually re-execute. after/plugin/*.lua and the current
-- buffer's after/ftplugin/<filetype>.lua aren't required as modules at all
-- (Neovim sources them directly, once, at startup), so they're re-sourced
-- by hand too.
local function reload_config()
    local config_path = vim.fn.stdpath('config')

    package.loaded['plugins'] = nil
    package.loaded['remap'] = nil

    local ok, err = pcall(vim.cmd, 'source ' .. config_path .. '/init.lua')
    if not ok then
        vim.notify('Config reload failed in init.lua: ' .. err, vim.log.levels.ERROR)
        return
    end

    for _, file in ipairs(vim.fn.glob(config_path .. '/after/plugin/*.lua', false, true)) do
        local plugin_ok, plugin_err = pcall(vim.cmd, 'source ' .. file)
        if not plugin_ok then
            vim.notify('Config reload failed in ' .. file .. ': ' .. plugin_err, vim.log.levels.ERROR)
        end
    end

    local ft = vim.bo.filetype
    if ft ~= '' then
        local ft_file = config_path .. '/after/ftplugin/' .. ft .. '.lua'
        if vim.fn.filereadable(ft_file) == 1 then
            pcall(vim.cmd, 'source ' .. ft_file)
        end
    end

    vim.notify('Config reloaded', vim.log.levels.INFO)
end

vim.api.nvim_create_user_command('ReloadConfig', reload_config, {
    desc = 'Re-source init.lua, lua/plugins.lua, lua/remap.lua, and all after/plugin/*.lua files',
})

vim.keymap.set('n', '<leader>rc', reload_config, { desc = 'Reload nvim config' })
