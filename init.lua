vim.g.loaded_matchparen = 1
require("plugins")
require("remap")
vim.g.mapleader = ' '
vim.cmd(':set shiftwidth=4')
vim.cmd(':set tabstop=4')
vim.cmd(':set relativenumber')
vim.cmd(':set textwidth=0') 
vim.cmd(':set wrapmargin=0')
vim.cmd('au ColorScheme * hi EndOfBuffer guifg=#282828 ctermfg=0') -- Hide tildes (matches default gruvbox/dark bg)
vim.cmd('set clipboard+=unnamedplus')
vim.cmd(':')
vim.g.netrw_banner = 0
local opt = vim.opt
opt.wrap = false
opt.termguicolors = true
opt.list = false -- Explicitly turn off list
opt.fillchars = { eob = " " } -- Replace tilde with space
opt.signcolumn = "yes" -- Always show sign column to prevent layout shift
