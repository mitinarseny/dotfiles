vim.g.nord_bold_vertical_split_line = true
vim.g.nord_uniform_diff_background  = true

vim.cmd('packadd! nord')

vim.cmd('colorscheme nord')
-- fix: remove background highlighting of Diff* groups
for _,g in ipairs({'DiffAdd', 'DiffChange', 'DiffDelete'}) do
  vim.highlight.create(g, {ctermbg='NONE', guibg='NONE'}, false)
end
