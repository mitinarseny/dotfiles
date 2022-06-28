vim.api.nvim_create_autocmd('UIEnter', {
  once = true,
  callback = function()
    local notify = require('notify')
    local wk = require('which-key')
    notify.setup({
      level = vim.log.levels.INFO,
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
      timeout = 3000,
    })
    vim.notify = notify

    wk.register({['<Leader>n'] = {name = 'notify'}})
    vim.keymap.set('n', '<Leader>nn', function()
      notify.dismiss({
        pending = true,
        silent = true,
      })
    end, {noremap = true, silent = true})
  end,
})
