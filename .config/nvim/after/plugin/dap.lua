local dap = require('dap')
require('dap-go').setup()

vim.keymap.set('n', '<Leader>db', dap.toggle_breakpoint,
  {noremap = true, silent = true, desc = 'DAP: Toggle breakpoint'})
vim.keymap.set('n', '<Leader>dB', function()
  dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end, {noremap = true, silent = true, desc = 'DAP: Set breakpoint condition'})
vim.keymap.set('n', '<Leader>dl', function()
  dap.set_breakpoint(nil, nil, vim.fn.input('Log breakpoint message: '))
end, {noremap = true, silent = true, desc = 'DAP: Set log point'})
vim.keymap.set('n', '<Leader>dc', dap.continue,
  {noremap = true, silent = true, desc = 'DAP: Continue'})
vim.keymap.set('n', '<Leader>ds', dap.step_over,
  {noremap = true, silent = true, desc = 'DAP: Step over'})
vim.keymap.set('n', '<Leader>di', dap.step_into,
  {noremap = true, silent = true, desc = 'DAP: Step into'})
vim.keymap.set('n', '<Leader>do', dap.step_out,
  {noremap = true, silent = true, desc = 'DAP: Step out'})
vim.keymap.set('n', '<Leader>d.', dap.run_to_cursor,
  {noremap = true, silent = true, desc = 'DAP: Run to cursor'})
vim.keymap.set('n', '<Leader>d<Up>', dap.up,
  {noremap = true, silent = true, desc = 'DAP: Go up'})
vim.keymap.set('n', '<Leader>d<Down>', dap.run_to_cursor,
  {noremap = true, silent = true, desc = 'DAP: Go down'})

