local t = require('telescope')
local ta = require('telescope.actions')
local tb = require('telescope.builtin')

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
    file_browser = {
      grouped = true,
      dir_icon = '',
      hijack_netrw = true,
    },
  },
})

require('neoclip').setup({
  content_spec_column = true,
})
for _, e in ipairs({
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
