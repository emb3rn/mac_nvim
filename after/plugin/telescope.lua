local builtin = require('telescope.builtin')

-- vim.keymap.set('n', '<leader><leader>', builtin.find_files, { desc = 'Telescope: Find Files (File Name)' })

vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'Telescope: Grep (Content Search)' })

require("telescope").setup({
	pickers = {
		find_files = {
			theme = "dropdown",
			previewer = false,
			layout_config = {
				width = 0.5,
				height = 0.4,
				prompt_position = "top",
			},
		},
	}
})
