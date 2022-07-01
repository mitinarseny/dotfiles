local fun = require('fun')
local dap = require('dap')

local function non_empty(...)
  return fun.filter(function(_, v)
    return v and v ~= ''
  end, ...)
end

function stringify(...)
  return fun.map(function(_, v)
    return tostring(v)
  end, ...)
end

local function formatify(f, ...)
  assert(type(f) == 'string')
  return fun.map(function(_, v)
    return f:format(v)
  end, ...)
end

local function groupify(...)
  return formatify('%%1(%s%%)', ...)
end

local function value(...)
  return non_empty(fun.map(function(_, v)
    if type(v) == 'function' then
      return v()
    end
    return v
  end, ...))
end

local function join(sep, ...)
  return table.concat(fun.icollect(value(...)), sep)
end

local function align(...)
  return table.concat(fun.icollect(groupify(value(...))), '%=')
end

local function hi(group, text)
  return ('%%#Status%s#%s%%*'):format(group, text)
end

local function hify(group, ...)
  assert(type(group) == 'string')
  return fun.map(function(_, s)
    return hi(group, s)
  end, ...)
end

local mode_hi = {
  n          = 'N',
  v          = 'V',
  V          = 'VL',
  ['CTRL-V'] = 'VB',
  s          = 'S',
  S          = 'SL',
  ['CTRL-S'] = 'SB',
  i          = 'I',
  R          = 'R',
  c          = 'C',
  ['!']      = 'Ex',
  t          = 'T',
}

local function mode()
  return hi('Mode'..(mode_hi[vim.fn.mode()] or ''), ' ')
end

local function filename()
  return hi('FileName', '%t')
end

local function git_head()
  local h = vim.b.gitsigns_head
  return h and hi('GitHead', ('[%s]'):format(h) or '')
end

local function git_stats()
  local gs = vim.b.gitsigns_status_dict
  if not gs then
    return
  end
  local function count(typ, sign, hl)
    local c = gs[typ]
    if (c or 0) > 0 then
      return hi('Git'..hl, ('%s%d'):format(sign, c))
    end
  end
  return join(' ', ipairs({
    count('added',   '+', 'Added'),
    count('changed', '~', 'Changed'),
    count('removed', '-', 'Removed'),
  }))
end

local function dap_status()
  if not dap.session() then
    return
  end
  return hi('DAP', (' %s '):format(dap.status()))
end

local function diagnostic(name, severity)
  local c = #vim.diagnostic.get(0, {severity = severity})
  if c == 0 then
    return ''
  end
  return hi(string.format('Diagnostics%s', name), ('%s%d'):format(
    (vim.fn.sign_getdefined(('DiagnosticSign%s'):formay(name))[1] or {}).text or '', c))
end

local function diagnostic_counts()
  return join(' ', ipairs({
    diagnostic('Info',  vim.diagnostic.severity.INFO),
    diagnostic('Hint',  vim.diagnostic.severity.HINT),
    diagnostic('Warn',  vim.diagnostic.severity.WARN),
    diagnostic('Error', vim.diagnostic.severity.ERROR),
  }))
end

local function lsp_indicator()
  local cs = vim.lsp.get_active_clients()
  if not next(cs) then
    return
  end
  local is_working = fun.one(fun.map(function(_, c)
    return next(c.requests) or fun.one(fun.map(function(_, p)
      return not p.done
    end, pairs(c.messages.progress)))
  end, ipairs(cs)))
  return hi('LSPIndicator'..(is_working and 'Working' or ''), '⚡')
end

vim.api.nvim_create_autocmd({'User'}, {
  pattern = {'LspProgressUpdate', 'LspRequest'},
  group = vim.api.nvim_create_augroup('StatusLineLSPIndicator', {clear = true}),
  desc = 'LSP indicator update',
  command = 'redrawstatus',
})

local function cursor_position()
  return hi('CursorPosition', join(':', ipairs({'%3l', '%-2c'})))
end

local function percentage()
  return hi('Percentage', '%3p%%')
end

local scroll_bar_blocks = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' }
local function scroll_bar()
  local tl = vim.api.nvim_buf_line_count(0)
  if tl == 0 then
    return
  end
  local cl = vim.api.nvim_win_get_cursor(0)[1]
  return hi('ScrollBar', string.rep(scroll_bar_blocks[math.floor(cl/tl * (#scroll_bar_blocks - 1)) + 1], 2))
end

-- vim.api.nvim_create_autocmd({'BufWinEnter'}, {
--   callback = function(opts)
--     vim.api.nvim_create_autocmd({'DiagnosticChanged'}, {
--       buffer = opts.buf,
--       group = vim.api.nvim_create_augroup('StatusLineDiagnostics', {clear = true}),
--       desc = 'Update diagnostic statusline indicators',
--       command = 'redrawstatus',
--     })
--   end,
-- })

-- TODO: conditional
return function()
  return align(ipairs({
    join(hi('Separator', ' '), ipairs({ -- TODO
      mode,
      git_head,
      filename,
      git_stats,
    })),
    dap_status,
    join(hi('Separator', ' '), ipairs({
      diagnostic_counts,
      lsp_indicator,
      cursor_position,
      percentage,
      scroll_bar,
    }))
  }))
end
