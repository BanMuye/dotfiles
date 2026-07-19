-- System
vim.opt.clipboard = 'unnamedplus' -- use system clipboard
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' } -- pop menu even with one option without selecting
vim.opt.mouse = 'a' -- allow use mouse

-- Tab
vim.opt.tabstop = 4 -- number of virtual spaces per Tab
vim.opt.softtabstop = 4 -- number of spaces in tab when editing
vim.opt.shiftwidth = 4 -- insert 4 spaces on a tab when shifting
vim.opt.expandtab = true -- change to spaces when tabbing

-- UI config
vim.opt.number = true -- show absolute number
vim.opt.relativenumber = true -- show relative number
vim.opt.cursorline = true --- highlight the cursor line underneath the cursor horizontally
vim.opt.splitbelow = true -- open new vertical window split below
vim.opt.splitright = true -- open new horizontal window split right
vim.opt.scrolloff = 2 -- keep 2 lines when scrolling vertially

-- Searching
vim.opt.incsearch = true -- search as characters are entered
vim.opt.hlsearch = true -- highlight matches
vim.opt.ignorecase = true -- ignore cases in search by default
vim.opt.smartcase = true -- but make it sensitive if an uppercase is entered
