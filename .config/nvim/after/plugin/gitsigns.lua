require('gitsigns').setup({
  signs = {
    add           = {text = '+'},
    change        = {text = '~'},
    delete        = {text = '_'},
    topdelte      = {text = '‾'},
    chandedelete  = {text = '≈'},
  },
  signcolumn = false,
  numhl      = true,
  linehl     = false,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'right_align',
    delay = 1000,
  },
  current_line_blame_formatter_opts = {
    relative_time = true,
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    map('n', '<Leader>g?', gs.toggle_current_line_blame,
      {noremap = true, desc = 'Toggle current line blame'})
    map('n', '<Leader>gd', gs.toggle_deleted,
      {noremap = true, desc = 'Toggle deleted'})
  end,
})
