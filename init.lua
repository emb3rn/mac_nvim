require("plugins")
require("remap")
vim.cmd(':set shiftwidth=4')
vim.cmd(':set tabstop=4')
vim.cmd(':set relativenumber')
vim.cmd(':set textwidth=0') 
vim.cmd(':set wrapmargin=0')
vim.cmd(':hi Normal guibg=NONE ctermbg=NONE')
vim.cmd('au ColorScheme * hi Normal ctermbg=None')
vim.cmd('set clipboard+=unnamedplus')
vim.cmd(':')
vim.g.netrw_banner = 0

