vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>tm", ":botright terminal<CR>", {silent = true})
vim.keymap.set("n", "<leader>nh", ":noh<CR>", {silent = true})
vim.keymap.set("n", "<leader>ut", vim.cmd.UndotreeToggle, {silent = true})
