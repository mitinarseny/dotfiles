require('gitsigns').setup({
  signs = {
    add           = {text = '+'},
    change        = {text = '~'},
    delete        = {text = '_'},
    topdelte      = {text = '‾'},
    chandedelete  = {text = '≈'},
  },
  signcolumn = true,
  numhl      = false,
  linehl     = false,
  on_attach = function(bufnr)
    vim.wo.signcolumn = 'yes'

    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    map('n', '<Leader>g?', gs.toggle_current_line_blame, {noremap = true})
  end,
})
