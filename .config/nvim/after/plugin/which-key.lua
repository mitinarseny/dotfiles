require('which-key').setup({
  plugins = {
    marks = true,
    registers = true,
    presets = {
      operators = false,
      motions = true,
      text_objects = true,
      windows = true,
      nav = true,
    },
  },
  icons = {
    breadcrumb = '+',
    separator = '➜',
    group = '+',
  },
  win = {
    border = 'none',
  },
  keys = {
    scroll_down = '<C-Down>',
    scroll_up = '<C-Up>',
  },
  layout = {
    align = 'center',
  },
})
