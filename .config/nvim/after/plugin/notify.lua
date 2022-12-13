vim.api.nvim_create_autocmd('UIEnter', {
  once = true,
  callback = function()
    local notify = require('notify')
    local stages_util = require("notify.stages.util")
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
      -- max_width = function()
      --   local c = math.floor(vim.go.columns)
      --   return c > 80 and c/2 or c
      -- end,
      timeout = 2000,
      stages = {
        function(state)
          local next_height = state.message.height + 2
          local next_row = stages_util.available_slot(
            state.open_windows,
            next_height,
            stages_util.DIRECTION.TOP_DOWN
          )
          if not next_row then
            return nil
          end
          return {
            relative = 'editor',
            anchor = 'NE',
            width = state.message.width,
            height = state.message.height,
            col = vim.opt.columns:get(),
            row = next_row,
            border = 'rounded',
            style = 'minimal',
          }
        end,
        function(state, win)
          return {
            row = {
              stages_util.slot_after_previous(win, state.open_windows, stages_util.DIRECTION.TOP_DOWN),
              frequency = 10,
              complete = function()
                return true
              end,
            },
            col = { vim.opt.columns:get() },
            time = true,
          }
        end,
      },
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
