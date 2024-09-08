local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>tf', builtin.find_files, {})
vim.keymap.set('n', '<leader>tw', function()
	builtin.grep_string({search = vim.fn.input("Grep > ") });
end)

require("telescope").setup({
	pickers = {
		find_files = {
			theme = "dropdown"
		},
	}
})
