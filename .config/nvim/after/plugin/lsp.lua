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
    end, { 'i', 'v' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn['vsnip#jumpable'](-1) == 1 then
        feedkey('<Plug>(vsnip-jump-prev)', '')
      else
        fallback()
      end
    end, { 'i', 'v' }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = "nvim_lsp_signature_help" },
    { name = 'vsnip' },
  }, {
    { name = 'buffer' },
    { name = 'path' },
  }),
  formatting = {
    format = function(entry, vim_item)
      vim_item.menu = ({
        buffer = '[Buffer]',
        nvim_lsp = '[LSP]',
        vsnip = '[Snip]',
        path = '[Path]',
      })[entry.source.name]
      return vim_item
    end,
  }
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

  local function map(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = bufnr
    vim.keymap.set(mode, l, r, opts)
  end

  local tb = require('telescope.builtin')
  map('n', '<C-]>', tb.lsp_definitions, {noremap = true, silent = true})
  map('n', '<Leader>lt', tb.lsp_type_definitions, {noremap = true, silent = true})
  map('n', '<Leader>lu', tb.lsp_references, {noremap = true, silent = true})
  map('n', '<Leader>li', tb.lsp_implementations, {noremap = true, silent = true})
  map('n', '<Leader>lr', vim.lsp.buf.rename, {noremap = true, silent = true})
  map('n', '<Leader>la', vim.lsp.buf.code_action, {noremap = true, silent = true})

  if client.resolved_capabilities.document_formatting then
    map('n', '<Leader>lf', vim.lsp.buf.formatting, {noremap = true, silent = true})
  end
  if client.resolved_capabilities.document_range_formatting then
    map('v', '<Leader>lf', vim.lsp.buf.range_formatting, {noremap = true, silent = true})
  end

  vim.api.nvim_create_autocmd({'CursorHold', 'CursorHoldI'}, {
    buffer = bufnr,
    callback = vim.lsp.buf.document_highlight,
  })
  vim.api.nvim_create_autocmd({'CursorMoved', 'CursorMovedI'}, {
    buffer = bufnr,
    callback = vim.lsp.buf.clear_references,
  })
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
