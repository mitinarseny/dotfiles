require('gitsigns').setup({
  signs = {
    add          = {hl = 'GitSignsAdd'   , text = '+', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
    change       = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    changedelete = {hl = 'GitSignsChange', text = '≈', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
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
