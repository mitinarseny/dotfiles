vim.api.nvim_create_autocmd('UIEnter', {
  once = true,
  callback = function()
    vim.cmd('colorscheme nord')
  end,
})
