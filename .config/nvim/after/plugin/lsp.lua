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
  local luasnip = require('luasnip')
  local cmp_autopairs = require('nvim-autopairs.completion.cmp')
  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = {
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_locally_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
        end
      end, { 'i', 'v' }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { 'i', 'v' }),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'nvim_lsp_signature_help' },
    }, {
      { name = 'luasnip'},
    }, {
      { name = 'buffer' },
      { name = 'path' },
    }),
    formatting = {
      format = function(entry, item)
        return vim.tbl_extend('force', item, {
          menu = ({
            nvim_lsp = '🗲',
            luasnip  = '⇢',
            buffer   = '☰',
            path     = '/',
          })[entry.source.name],
        })
      end,
    }
  })
  cmp.setup.cmdline('/', {
    view = {
      entries = { name = 'wildmenu', separator = '|' },
    },
  })
  cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
  vim.opt.completeopt = {'menu', 'menuone', 'noselect', 'preview'}
  end,
})

local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
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
    cmd = { 'rustup', 'run', 'nightly', 'rust-analyzer' },
    settings = {
      ['rust-analyzer'] = {
        assist = {
          importGranularity = "module",
          importPrefix      = "self",
        },
      },
    },
  },
}) do
  cfg.capabilities = vim.tbl_extend('keep', cfg.capabilities or {}, capabilities)
  cfg.on_attach = function(client, bufnr)
    vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'
    vim.wo.signcolumn = 'yes'

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    local tb = require('telescope.builtin')
    local wk = require('which-key')

    wk.register({['<Leader>l'] = {name = 'LSP'}}, {buffer = bufnr})
    if client.server_capabilities.definitionProvider then
      map('n', '<C-]>', vim.lsp.buf.definition,
        {noremap = true, silent = true, desc = 'Definition'})
    end
    if client.server_capabilities.typeDefinitionProvider then
      map('n', '<Leader>lt', vim.lsp.buf.type_definition,
        {noremap = true, silent = true, desc = 'Type definition'})
    end
    if client.server_capabilities.referencesProvider then
      map('n', '<Leader>lu', vim.lsp.with(vim.lsp.buf.references, {
          includeDeclaration = false,
        }), {noremap = true, silent = true, desc = 'References'})
    end
    if client.server_capabilities.implementationProvider then
      map('n', '<Leader>li', vim.lsp.buf.implementation,
        {noremap = true, silent = true, desc = 'Implementation'})
    end
    map('n', '<Leader>lr', vim.lsp.buf.rename,
      {noremap = true, silent = true, desc = 'Rename'})
    map('n', '<Leader>la', vim.lsp.buf.code_action,
      {noremap = true, silent = true, desc = 'Code actions'})
    if client.server_capabilities.hoverProvider then
      map('n', '<Leader>lh', vim.lsp.buf.hover,
          {noremap = true, silent = true, desc = 'Hover'})
    end
    if client.server_capabilities.workspaceSymbolProvider then
      map('n', '<Leader>ls', tb.lsp_dynamic_workspace_symbols,
          {noremap = true, silent = true, desc = 'Search symbols'})
    end
    if client.server_capabilities.inlayHintProvider then
      map('n', '<Leader>ld', vim.diagnostic.open_float,
          {noremap = true, silent = true, desc = 'Line diagnostic'})
    end
    if client.server_capabilities.documentFormattingProvider then
      map('n', '<Leader>lf', vim.lsp.buf.format,
        {noremap = true, silent = true, desc = 'Format'})
    end
    if client.server_capabilities.documentRangeFormattingProvider then
      map('v', '<Leader>lf', vim.lsp.buf.format,
        {noremap = true, silent = true, desc = 'Format'})
    end

    if client.server_capabilities.documentHighlightProvider then
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
    end
  end

  lspconfig[s].setup(cfg)
end

-- require('rust-tools').setup({})

vim.api.nvim_create_autocmd({'UIEnter'}, {
  once = true,
  callback = function()
    local Spinner = require('spinner')
    local spinners = {}

    local function format_msg(msg, percentage)
      msg = msg or ''
      if not percentage then
        return msg
      end
      return ('%2d%%\t%s'):format(percentage, msg)
    end

    vim.api.nvim_create_autocmd({'User'}, {
      pattern = {'LspProgressUpdate'},
      group = vim.api.nvim_create_augroup('LSPNotify', {clear = true}),
      desc = 'LSP progress notifications',
      callback = function()
        -- TODO: use one spinner for all tokens of each client
        for _, c in ipairs(vim.lsp.get_active_clients()) do
          for token, ctx in pairs(c.messages.progress) do
            if not spinners[c.id] then
              spinners[c.id] = {}
            end
            local s = spinners[c.id][token]
            if not ctx.done then
              if not s then
                spinners[c.id][token] = Spinner(
                  format_msg(ctx.message, ctx.percentage), vim.log.levels.INFO, {
                    title = ctx.title and ('%s: %s'):format(c.name, ctx.title) or c.name
                  })
              else
                s:update(format_msg(ctx.message, ctx.percentage))
              end
            else
              c.messages.progress[token] = nil
              if s then
                s:done(ctx.message or 'Complete', nil, {
                  icon = '',
                })
                spinners[c.id][token] = nil
              end
            end
          end
        end
      end,
    })
  end,
})

