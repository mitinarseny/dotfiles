vim.api.nvim_create_autocmd('InsertEnter', {
  once = true,
  callback = function()
    local function has_words_before()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  local function feedkey(key, mode)
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
  end,
})

local function mapf(...)
  local fs = {...}
  return function(...)
    for _, f in ipairs(fs) do
      f(...)
    end
  end
end

local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
for s, cfg in pairs({
  clangd = {
    cmd = { 'clangd', '--background-index', '--enable-config' },
    -- handlers = lsp_status.extensions.clangd.setup(),
    init_options = {
      clangdFileStatus = true,
    },
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
}) do
  cfg.capabilities = vim.tbl_extend('keep', cfg.capabilities or {}, capabilities)
  cfg.on_attach = mapf(function(client, bufnr)
    vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'
    vim.wo.signcolumn = 'yes'

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    local wk = require('which-key')

    wk.register({['<Leader>l'] = {name = 'LSP'}}, {buffer = bufnr})
    map('n', '<C-]>', vim.lsp.buf.definition,
      {noremap = true, silent = true, desc = 'Definition'})
    map('n', '<Leader>lt', vim.lsp.buf.type_definition,
      {noremap = true, silent = true, desc = 'Type definition'})
    map('n', '<Leader>lu', function()
      -- TODO: trim results
      vim.lsp.buf.references({ includeDeclaration = false })
    end, {noremap = true, silent = true, desc = 'References'})
    map('n', '<Leader>li', vim.lsp.buf.implementation,
      {noremap = true, silent = true, desc = 'Implementation'})
    map('n', '<Leader>lr', vim.lsp.buf.rename,
      {noremap = true, silent = true, desc = 'Rename'})
    map('n', '<Leader>la', vim.lsp.buf.code_action,
      {noremap = true, silent = true, desc = 'Code actions'})

    if client.resolved_capabilities.document_formatting then
      map('n', '<Leader>lf', vim.lsp.buf.formatting,
        {noremap = true, silent = true, desc = 'Format'})
    end
    if client.resolved_capabilities.document_range_formatting then
      map('v', '<Leader>lf', vim.lsp.buf.range_formatting,
        {noremap = true, silent = true, desc = 'Format'})
    end

    vim.api.nvim_create_autocmd({'CursorHold', 'CursorHoldI'}, {
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({
      'CursorMoved', 'CursorMovedI',
      'InsertLeavePre',
      'TextChanged', 'TextChangedI',
    }, {
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end, cfg.on_attach or function()
  end)
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

local Spinner = require('spinner')

local spinners = {}

local function new_spinner(client_id, token, s)
  if not spinners[client_id] then
    spinners[client_id] = {}
  end
  spinners[client_id][token] = s
end

local function get_spinner(client_id, token)
  return (spinners[client_id] or {})[token]
end

local function delete_spinner(client_id, token)
  if not spinners[client_id] then
    return
  end
  spinners[client_id][token] = nil
end

local function format_title(title, client_name)
 return client_name .. (#title > 0 and ": " .. title or "")
end

local function format_message(message, percentage)
  if not percentage then
    return message or ''
  end
  return string.format('%2d%%\t%s', percentage, message or '')
end

vim.lsp.handlers['$/progress'] = function(_, result, ctx)
  local client_id = ctx.client_id
  local val = result.value
  if not val.kind then
   return
  end

  if val.kind == 'begin' then
    new_spinner(client_id, result.token, Spinner(
      format_message(val.message, val.percentage),
      vim.log.levels.INFO, {
        title = format_title(val.title, vim.lsp.get_client_by_id(client_id).name),
      }))
  else
    local s = get_spinner(client_id, result.token)
    if not s then
      return
    end
    if val.kind == 'report' then
      -- TODO: cancellable
      s:update(format_message(val.message, val.percentage))
    elseif val.kind == 'end' then
      s:done(val.message or 'Complete', nil, {
        icon = '',
      })
      delete_spinner(client_id, result.token)
    end
  end
end
