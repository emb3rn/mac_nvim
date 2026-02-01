local status, fff = pcall(require, "fff")
if not status then
    return
end

fff.setup({
	preview = {
		enabled = false,
	},
	layout = {
		prompt_position = "top",
		rounding = 0,
		gap = 0,
	}
})

-- Keymaps
-- Replicating <leader><leader> from telescope for finding files
vim.keymap.set('n', '<leader><leader>', fff.find_files, { desc = 'FFF: Find Files' })

-- Note: fff.nvim focuses on file finding and does not currently have a direct equivalent 
-- to Telescope's live_grep (<leader>sg). 
-- If you need grep functionality, you might need another tool or to keep Telescope installed.
