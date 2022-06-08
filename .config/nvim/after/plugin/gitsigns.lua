require('gitsigns').setup({
  signs = {
    add           = {text = '+'},
    change        = {text = '~'},
    delete        = {text = '_'},
    topdelte      = {text = '‾'},
    chandedelete  = {text = '≈'},
  },
  signcolumn = true,
  numhl      = false,
  linehl     = false,
})
vim.keymap.set('n', '<Leader>g?', "<Cmd>lua require('gitsigns').toggle_current_line_blame()<CR>",
  {noremap = true, silent = true})
