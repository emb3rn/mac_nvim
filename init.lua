-- Leader must be set before plugins/remap load, since both define
-- <leader>-prefixed keymaps at require-time.
vim.g.mapleader = ' '
vim.g.loaded_matchparen = 1
vim.g.netrw_banner = 0

require('remap')
require('plugins')

local opt = vim.opt
opt.number = true
opt.relativenumber = true -- hybrid: cursor line shows its real number
opt.shiftwidth = 4
opt.tabstop = 4
opt.textwidth = 0
opt.wrapmargin = 0
opt.wrap = false
opt.termguicolors = true
opt.list = false
opt.fillchars = { eob = ' ' } -- hide the ~ tilde fill on empty lines
opt.signcolumn = 'yes' -- always show sign column to prevent layout shift
opt.clipboard:append('unnamedplus')
opt.cursorline = true -- subtle highlight on the line under the cursor
