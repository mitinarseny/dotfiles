require('nvim-treesitter.configs').setup({
  ensure_installed = {
    'c', 'cpp',
    'comment',
    'dockerfile',
    'go',
    'gomod',
    'json', 'json5',
    'lua',
    'make',
    'markdown',
    'python',
    'rust',
    'toml',
  },
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
})
