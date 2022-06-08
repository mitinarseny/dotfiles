-- TODO: :help vmenu
vim.g.mapleader = ' '

vim.opt.whichwrap = {
  ['<'] = true,
  ['>'] = true,
  ['['] = true,
  [']'] = true,
} -- allow arrow keys to move to next/previous line
vim.opt.keymodel = {'startsel', 'stopsel'} -- shifted cursor keys selects, unshifted - deselects
vim.o.selection = 'old' -- do not include newline when selecting
vim.opt.selectmode = {'mouse', 'key'} -- go to select mode, instead of visual
vim.keymap.set('v', '<A-c>', '"+y', {noremap = true, desc = 'Copy'})
vim.keymap.set('n', '<A-c>', '"+yy', {noremap = true, desc = 'Copy current line'})
vim.keymap.set('v', '<A-x>', '"+dgV', {noremap = true, desc = 'Cut'})
vim.keymap.set('n', '<A-x>', '"+ddgV', {noremap = true, desc = 'Cut current line'})
vim.keymap.set('', '<A-v>', 'gP', {noremap = true, desc = 'Paste'})
vim.keymap.set('!', '<A-v>', '<C-R><C-O>+', {noremap = true, desc = 'Paste'})

-- undo and changes
vim.keymap.set('n', '<A-z>', 'u', {noremap = true, desc = 'Undo'})
vim.keymap.set('n', '<A-Z>', '<C-R>', {noremap = true, desc = 'Redo'})

vim.keymap.set('i', '<S-Up>', function()
  if vim.fn.wincol() == 1 then
    return '<C-O>gk<C-O>gh<C-O>g$<C-O>o'
  end
  return '<Left><C-O><S-Up>'
end, {expr = true, remap = true, silent = true, desc = 'Start selection by graphical lines'})
vim.keymap.set('i', '<S-Down>', '<C-O><S-Down>',
  {remap = true, desc = 'Start selection by graphical lines'})
for k, v in pairs({
  ['Up']   = {
    kk = 'k',
    lower = function() return vim.fn.line('.')     >  vim.fn.line('v') end,
  },
  ['Down'] = {
    kk = 'j',
    lower = function() return vim.fn.line('.') + 1 >= vim.fn.line('v') end,
  },
}) do
  vim.keymap.set('n', '<'..k..'>', 'g<'..k..'>', {noremap = true, desc = 'Move by graphical lines'})
  vim.keymap.set({'x', 's'}, '<'..k..'>', '<Esc><'..k..'>',
    {remap = true, desc = 'Abort selection and move by graphical lines'})
  vim.keymap.set('i', '<'..k..'>', function()
    return (vim.fn.pumvisible() == 1 and '' or '<C-O>') .. '<'..k..'>'
  end, {expr = true, remap = true, silent = true, desc = 'Move by graphical lines'})

  vim.keymap.set('v', '<S-'..k..'>', function()
    if vim.fn.mode() ~= 'V' then
      return 'g<'..k..'>'
    end
    local is_lower = v.lower()
    return 'o'..(is_lower and '0' or '$')..'o'..v.kk..(is_lower and '$' or '0')
  end, {expr = true, noremap = true, silent = true, desc = 'Move by graphical or line-wise'})
  vim.keymap.set('v', '<S-C-'..k..'>', function()
    return (vim.fn.mode() ~= 'V' and 'V' or '')..'<S-'..k..'>'
  end, {expr = true, remap = true, silent = true, desc = 'Move line-wise'})
  vim.keymap.set('n', '<S-'..k..'>', 'gh<S-'..k..'>',
    {remap = true, desc = 'Start selection'})
  vim.keymap.set('n', '<S-C-'..k..'>', 'gH<S-'..k..'>',
    {remap = true, desc = 'Start linewise selection'})
  vim.keymap.set('i', '<S-C-'..k..'>', '<C-O><S-A-'..k..'>',
    {remap = true, desc = 'Start linewise selection'})
end

-- jump by words
for k, v in pairs({
    ['Right'] = 'e',
    ['Left'] = 'b',
}) do
  vim.keymap.set('n', '<C-'..k..'>', v, {noremap = true, desc = 'Jump by word'})
  vim.keymap.set({'x', 's'}, '<C-'..k..'>', '<Esc><A-'..k..'>',
    {remap = true, desc = 'Abort selection and jump by word'})
  vim.keymap.set('v', '<S-'..k..'>', function()
    return (vim.fn.mode() == 'V' and 'v' or '')..'<S-'..k..'>'
  end, {expr = true, noremap = true, silent = true, desc = 'Switch from line-wise to char-wise'})
  vim.keymap.set('v', '<S-C-'..k..'>', function()
    return (vim.fn.mode() == 'V' and 'v' or '')..v
  end, {expr = true, noremap = true, silent = true, desc = 'Select by word char-wise'})
  vim.keymap.set('n', '<S-C-'..k..'>', 'gh<S-C-'..k..'>', {remap = true, desc = 'Select by word'})
  vim.keymap.set('i', '<S-C-'..k..'>', '<C-O><S-C-'..k..'>', {remap = true, desc = 'Select by word'})
end

vim.keymap.set('n', '<Home>', function()
  return vim.fn.indent('.')+1==vim.fn.virtcol('.') and '0' or '^'
end, {expr = true, noremap = true, silent = true, desc = 'Go to first non-black character in line'})
vim.keymap.set({'x', 's'}, '<Home>', '<Esc><Home>',
  {remap = true, desc = 'Abort selection and go to first non-blank character in line'})
vim.keymap.set('i', '<Home>', '<C-O><Home>',
  {remap = true, desc = 'Go to first non-blank character in line'})
vim.keymap.set('v', '<S-Home>', function()
  return (vim.fn.mode() == 'V' and 'v' or '')..(vim.fn.indent('.')+1==vim.fn.virtcol('.') and '0' or '^')
end, {expr = true, noremap = true, silent = true, desc = 'Go to first non-blank character in line (char-wise)'})
vim.keymap.set('n', '<S-Home>', 'gh<S-Home>',
  {remap = true, desc = 'Select until first non-blank character in line'})
vim.keymap.set('i', '<S-Home>', '<C-O><S-Home>',
  {remap = true, desc = 'Select until first non-blank character in line'})

vim.keymap.set('n', '<C-Home>', '<C-Home>0', {noremap = true, desc = 'Go to the beginning of the file'})
vim.keymap.set({'x', 's'}, '<C-Home>', '<Esc><C-Home>',
  {remap = true, desc = 'Abort selection and go to the beginning of the file'})
vim.keymap.set('i', '<C-Home>', '<C-O><C-Home>',
  {remap = true, desc = 'Go to the beginning of the file'})
vim.keymap.set({'x', 's'}, '<C-End>', '<Esc><C-End>',
  {remap = true, desc = 'Abort selection and go to the end of the file'})
vim.keymap.set('i', '<C-End>', '<C-O><C-End>',
  {remap = true, desc = 'Go to the beginning of the file'})

vim.keymap.set('v', '<S-C-Home>', '<S-C-Home>0',
  {noremap = true, desc = 'Go to the beginning of the file'})
for _, k in ipairs({'Home', 'End'}) do
  vim.keymap.set('n', '<S-C-'..k..'>', 'gh<S-C-'..k..'>', {remap = true})
  vim.keymap.set('i', '<S-C-'..k..'>', '<C-O><S-C-'..k..'>',{remap = true})
end

vim.keymap.set('v', '<A-a>', function()
  return '<S-C-Home>o'..(vim.fn.mode() ~= 'V' and 'V' or '')..'<S-C-End>'
end, {expr = true, remap = true, silent = true, desc = 'Select all'})
vim.keymap.set('n', '<A-a>', 'gH<A-a>', {remap = true, desc = 'Select all'})
vim.keymap.set('i', '<A-a>', '<C-O><A-a>', {remap = true, desc = 'Select all'})

-- <C-H> is <C-BS>
vim.keymap.set('n', '<C-H>', 'db', {noremap = true, desc = 'Delete word backwards'})
vim.keymap.set('!', '<C-H>', '<C-W>', {noremap = true, desc = 'Delete word backwards'})
vim.keymap.set('n', '<C-A-H>', 'd0',
  {noremap = true, desc = 'Delete to the beginning of the line'})
vim.keymap.set('!', '<C-A-H>', '<C-U>',
  {noremap = true, desc = 'Delete to the beginning of the line'})

for k, v in pairs({
  ['Tab'] = '>',
  ['S-Tab'] = '<'
}) do
  vim.keymap.set('v', '<'..k..'>', function()
    local lower = vim.fn.line('.') >= vim.fn.line('v')
    return v..'gv'..(vim.fn.mode() ~= 'V' and 'V' or '')..
      'o'..(lower and '^' or '$')..'o'..(lower and '$' or '^')
  end, {expr = true, noremap = true, silent = true})
end
vim.keymap.set('i', '<C-Tab>', '<C-T>', {noremap = true, desc = 'Indent current line'})
vim.keymap.set('i', '<S-Tab>', '<C-D>', {noremap = true, desc = 'Unindent current line'})

vim.keymap.set('', '<C-W>!', '<C-W>T', {noremap = true, desc = 'Move current window to a new tab'})

vim.keymap.set('', '<C-W>\\', '<Cmd>vertical          split<CR>', {noremap = true})
vim.keymap.set('', '<C-W>|',  '<Cmd>vertical botright split<CR>', {noremap = true})
vim.keymap.set('', '<C-W>-',  '<Cmd>                  split<CR>', {noremap = true})
vim.keymap.set('', '<C-W>_',  '<Cmd>         botright split<CR>', {noremap = true})

vim.keymap.set('', '<C-W><Tab>', '<C-W>p', {noremap = true, desc = 'Go to previous window'})

-- TODO: filetype help: do not highlight current line, scroll whole screen
