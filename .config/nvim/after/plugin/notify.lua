notify = require('notify')
notify.setup({
  level = vim.log.levels.INFO,
  timeout = 5000,
  background_colour = 'Normal',
  icons = {
    TRACE = '⇣',
    DEBUG = '🐞',
    INFO  = '🛈',
    WARN  = '⚠',
    ERROR = '',
  },
  render = 'default',
  stages = 'static',
})
vim.notify = notify

vim.keymap.set('n', '<Leader>nn', function()
  notify.dismiss({
    pending = true,
    silent = true,
  })
end, {noremap = true, silent = true})
