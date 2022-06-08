vim.cmd('packadd! indent-blankline')
require('indent_blankline').setup({
  char = '|',
  show_first_indent_level        = false,
  show_trailing_blankline_indent = false,
})
vim.cmd('packadd indent-blankline')
