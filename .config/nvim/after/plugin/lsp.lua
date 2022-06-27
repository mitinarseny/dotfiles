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

local servers = {
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
}

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
for s, cfg in pairs(servers) do
  cfg.capabilities = vim.tbl_extend('keep', cfg.capabilities or {}, capabilities)
  cfg.on_attach = mapf(function(client, bufnr)
    vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'
    vim.wo.signcolumn = 'yes'

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    map('n', '<C-]>', vim.lsp.buf.definition, {noremap = true, silent = true})
    map('n', '<Leader>lt', vim.lsp.buf.type_definition, {noremap = true, silent = true})
    map('n', '<Leader>lu', function()
      vim.lsp.buf.references({ includeDeclaration = false })
    end, {noremap = true, silent = true})
    map('n', '<Leader>li', vim.lsp.buf.implementation, {noremap = true, silent = true})
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

local client_notifs = {}

local function get_notif_data(client_id, token)
 if not client_notifs[client_id] then
   client_notifs[client_id] = {}
 end

 if not client_notifs[client_id][token] then
   client_notifs[client_id][token] = {}
 end

 return client_notifs[client_id][token]
end


local spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }

local function update_spinner(client_id, token)
 local notif_data = get_notif_data(client_id, token)

 if notif_data.spinner then
    local new_spinner = (notif_data.spinner + 1) % #spinner_frames
    notif_data.spinner = new_spinner

    notif_data.notification = vim.notify(nil, nil, {
      hide_from_history = true,
      icon = spinner_frames[new_spinner],
      replace = notif_data.notification,
    })

    vim.defer_fn(function()
      update_spinner(client_id, token)
    end, 100)
 end
end

local function format_title(title, client_name)
 return client_name .. (#title > 0 and ": " .. title or "")
end

local function format_message(message, percentage)
 return (percentage and percentage .. "%\t" or "") .. (message or "")
end

vim.lsp.handlers["$/progress"] = function(_, result, ctx)
 local client_id = ctx.client_id

 local val = result.value

 if not val.kind then
   return
 end

 local notif_data = get_notif_data(client_id, result.token)

 if val.kind == "begin" then
   local message = format_message(val.message, val.percentage)

   notif_data.notification = vim.notify(message, vim.log.levels.INFO, {
     title = format_title(val.title, vim.lsp.get_client_by_id(client_id).name),
     icon = spinner_frames[1],
     timeout = false,
     hide_from_history = false,
   })

   notif_data.spinner = 1
   update_spinner(client_id, result.token)
 elseif val.kind == "report" and notif_data then
   notif_data.notification = vim.notify(format_message(val.message, val.percentage), vim.log.levels.INFO, {
     replace = notif_data.notification,
     hide_from_history = false,
   })
 elseif val.kind == "end" and notif_data then
   notif_data.notification =
     vim.notify(val.message and format_message(val.message) or "Complete", vim.log.levels.INFO, {
       icon = "",
       replace = notif_data.notification,
       timeout = 3000,
     })

   notif_data.spinner = nil
 end
end
