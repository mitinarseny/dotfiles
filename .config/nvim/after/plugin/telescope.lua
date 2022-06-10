local t = require('telescope')
local ta = require('telescope.actions')
local tb = require('telescope.builtin')
local tt = require('telescope.themes')
local tp = require('telescope.previewers')

local function limit_size_preview_maker(filepath, bufnr, opts)
  opts = opts or {}

  filepath = vim.fn.expand(filepath)
  vim.loop.fs_stat(filepath, function(_, stat)
    if not stat or stat.size > 100000 then return end
    tp.buffer_previewer_maker(filepath, bufnr, opts)
  end)
end

t.setup({
  defaults = {
    mappings = {
      i = {
        ['<Esc>'] = ta.close,
      },
    },
    sorting_strategy = 'ascending',
    layout_strategy = 'flex',
    layout_config = {
      prompt_position = 'top',
    },
    color_devicons = false,
    buffer_previewer_maker = limit_size_preview_maker,
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--trim',
    },
  },
  extensions = {
    ['ui-select'] = {
      tt.get_cursor()
    },
    file_browser = {
      grouped = true,
      hidden = true,
      dir_icon = '',
      hijack_netrw = true,
      -- TODO: clear empty prompt -> up
    },
  },
})

require('neoclip').setup({
  content_spec_column = true,
})
for _, e in ipairs({
  'ui-select',
  'file_browser',
  'neoclip',
  'lsp_handlers',
  'dap',
}) do
  t.load_extension(e)
end

vim.keymap.set('n', '<Leader><Space>', t.extensions.file_browser.file_browser, {noremap = true})
vim.keymap.set('n', '<Leader>ff', function()
  local opts = {}
  return pcall(tb.git_files, opts) or tb.find_files(opts)
end, {noremap = true})
vim.keymap.set('n', '<Leader>fg', tb.live_grep, {noremap = true})
vim.keymap.set('n', '<Leader>vb', tb.buffers, {noremap = true})

vim.keymap.set('n', '<Leader>gc', function()
  if not pcall(tb.git_commits, {}) then
    vim.notify(string.format('Not a Git repository: %s', vim.fn.getcwd()), vim.log.levels.WARN)
  end
end, {noremap = true})
vim.keymap.set('n', '<Leader>gb', function()
  if not pcall(tb.git_branches, {}) then
    vim.notify(string.format('Not a Git repository: %s', vim.fn.getcwd()), vim.log.levels.WARN)
  end
end, {noremap = true})

vim.keymap.set('n', '<Leader>dv', t.extensions.dap.variables, {noremap = true})
vim.keymap.set('n', '<Leader>df', t.extensions.dap.frames, {noremap = true})

