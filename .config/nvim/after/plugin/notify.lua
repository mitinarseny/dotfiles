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
      -- max_width = function()
      --   local c = math.floor(vim.go.columns)
      --   return c > 80 and c/2 or c
      -- end,
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
