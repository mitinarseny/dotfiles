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
  window = {
    border = 'none',
    position = 'bottom',
    margin = {1, 0, 1, 0},
    padding = {1, 0, 1, 0},
  },
  popup_mappings = {
    scroll_down = '<C-Down>',
    scroll_up = '<C-Up>',
  },
  layout = {
    align = 'center',
  },
})
