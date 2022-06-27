vim.api.nvim_create_autocmd('UIEnter', {
  callback = function()
    vim.go.laststatus = 3 -- shared status line for all windows
    vim.o.statusline = [[%{%v:lua.require('status_line')()%}]]
    vim.go.showmode = false
  end,
})
