if tonumber(vim.o.t_Co) > 1 then
  vim.cmd([[syntax enable]]) -- enable syntax highlighting if terminal supports colors
end
vim.o.cursorline = true
