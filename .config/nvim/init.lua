vim.o.hidden = true -- do not unload buffer when it is abandoned

vim.o.autoread = true -- read changes outside of vim

-- do not make backups before writing to file
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false

vim.opt.clipboard:append({'unnamedplus'}) -- use system clipboard

-- TODO: set updatetime=500

vim.o.ignorecase = true -- ignore case in search patterns
-- enable command-line completion
vim.o.wildmenu = true
vim.opt.wildignore = {'*.o', '*~', '*.pyc'}
vim.opt.wildignore:append({'*/.git/*', '*/.hg/*', '*/.svn/*', '*/.DS_Store'})
