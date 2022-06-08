local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn['vsnip#anonymous'](args.body)
    end,
  },
  mapping = {
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn['vsnip#available'](1) == 1 then
        feedkey('<Plug>(vsnip-expand-or-jump)', '')
      elseif has_words_before() then
        cmp.complete()
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn['vsnip#jumpable'](-1) == 1 then
        feedkey('<Plug>(vsnip-jump-prev)', '')
      end
    end, { 'i', 's' }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = "nvim_lsp_signature_help" },
    { name = 'vsnip' },
    { name = 'path' },
  }, {
    { name = 'buffer' },
  }),
  format = function(entry, vim_item)
    vim_item.menu = ({
      buffer = '[Buffer]',
      nvim_lsp = '[LSP]',
    })[entry.source.name]
  return vim_item
  end,
})
cmp.setup.cmdline('/', {
  view = {
    entries = { name = 'wildmenu', separator = '|' },
  },
})

vim.opt.completeopt = {'menu', 'menuone', 'noselect', 'preview'}

local on_lsp_attach = function(client, bufnr)
  vim.api.nvim_exec('highlight LspReferenceText cterm=underline gui=underline', true)

  local root = vim.lsp.buf.list_workspace_folders()[1]
  if root ~= nil then
    vim.api.nvim_exec('lcd '..root, true)
  end

  vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'

  vim.keymap.set('n', '<C-]>', "<Cmd>lua require('telescope.builtin').lsp_definitions()<CR>",
    {noremap = true, silent = true})
  vim.keymap.set('n', '<Leader>lu', "<Cmd>lua require('telescope.builtin').lsp_references()<CR>",      {noremap = true, silent = true})
  vim.keymap.set('n', '<Leader>li', "<Cmd>lua require('telescope.builtin').lsp_implementations()<CR>", {noremap = true, silent = true})
  vim.keymap.set('n', '<Leader>la', "<Cmd>lua require('telescope.builtin').lsp_code_actions()<CR>",    {noremap = true, silent = true})
  vim.keymap.set('n', '<Leader>lr', '<Cmd>lua vim.lsp.buf.rename()<CR>',                               {noremap = true, silent = true})
  vim.keymap.set('n', '<Leader>lh', '<Cmd>lua vim.lsp.buf.hover()<CR>',                                {noremap = true, silent = true})

  if client.resolved_capabilities.document_formatting then
    vim.keymap.set('n', '<Leader>lf', '<Cmd>lua vim.lsp.buf.formatting()<CR>', {noremap = true, silent = true})
  end
  if client.resolved_capabilities.document_range_formatting then
    vim.keymap.set('v', '<Leader>lf', '<Cmd>lua vim.lsp.buf.range_formatting()<CR>', {noremap = true, silent = true})
  end

  -- TODO: map to highlight references
  -- if client.resolved_capabilities.document_highlight then
  --   vim.api.nvim_exec([[
  --     autocmd CursorHold,CursorHoldI   <buffer> lua vim.lsp.buf.document_highlight()
  --     autocmd CursorMoved,CursorMovedI <buffer> lua vim.lsp.buf.clear_references()
  --   ]], true)
  -- end

  -- vim.keymap.set('i', '<Tab>',   'v:lua.tab_complete()',   {expr = true, silent = true})
  -- vim.keymap.set('s', '<Tab>',   'v:lua.tab_complete()',   {expr = true, silent = true})
  -- vim.keymap.set('i', '<S-Tab>', 'v:lua.s_tab_complete()', {expr = true, silent = true})
  -- vim.keymap.set('s', '<-STab>', 'v:lua.s_tab_complete()', {expr = true, silent = true})

  -- vim.keymap.set('i', '<CR>',      'compe#confirm("<CR>")', {expr = true, silent = true})
  -- vim.keymap.set('i', '<C-Space>', 'compe#complete()',      {expr = true, silent = true})
  -- vim.keymap.set('i', '<C-e>',     'compe#close("<C-e>")',  {expr = true, silent = true})
end

local servers = {
  clangd = {
    cmd = { 'clangd', '--background-index', '--enable-config' },
  },
  gopls = {
    settings = {
      gopls = {
        analyses = {
          fieldalignment = true,
          nilness        = true,
          unusedparams   = true,
          unusedwrite    = true,
        },
        staticcheck = true,
      },
    },
    init_options = {
      usePlaceholders = true,
    },
  },
  pyright = {},
  rust_analyzer = {
    settings = {
      ['rust-analyzer'] = {
        assist = {
          importGranularity = "module",
          importPrefix      = "by_self",
        },
      },
    },
  },
}

local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true
for s, cfg in pairs(servers) do
  cfg.on_attach = on_lsp_attach
  cfg.capabilities = capabilities
  lspconfig[s].setup(cfg)
end

require('lsp_extensions').inlay_hints({
  prefix = '=>',
  highlight = 'Comment',
  enabled = {
    'TypeHint',
    'ParameterHint',
  },
})
