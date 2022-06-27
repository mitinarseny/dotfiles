require('nvim-treesitter.configs').setup({
  ensure_installed = {
    'c',
    'lua',
    'go',
    'rust',
  },
  highlight = {
    enable = true,
  },
})
