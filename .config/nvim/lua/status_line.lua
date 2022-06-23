local dap = require('dap')

local function map(f, gen, ...)
  return function(...)
    local param, v = gen(...)
    if param then
      return param, v and f(v)
    end
  end, ...
end

local function filter(f, gen, ...)
  return function(state, param)
    local v
    repeat
      param, v = gen(state, param)
    until not param or f(param, v)
    return param, v
  end, ...
end

local function collect(...)
  local t = {}
  for _, tt in ... do
    if tt then
      table.insert(t, tt)
    end
  end
  return t
end

local function non_empty(...)
  return filter(function(_, v)
    return v and v ~= ''
  end, ...)
end

local function stringify(...)
  return map(tostring, ...)
end

local function formatify(f, ...)
  return map(function(...)
    return string.format(f, ...)
  end, ...)
end

local function groupify(...)
  return formatify('%%1(%s%%)', ...)
end

local function join(sep, ...)
  return table.concat(collect(groupify(non_empty(map(function(v)
    if type(v) == 'function' then
      return v()
    end
    return v
  end, ...)))), sep)
end

local function align(...)
  return join('%=', ...)
end


local function hi(group, text)
  return string.format('%%#Status%s#%s%%*', group, text)
end

local function hify(group, ...)
  return map(function(s)
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
  return hi(string.format('Mode%s', mode_hi[vim.fn.mode()] or ''), ' ')
end

local function filename()
  return hi('FileName', '%t')
end

local function git_head()
  local h = vim.b.gitsigns_head
  return h and hi('GitHead', string.format('[%s]', h) or '')
end

local function git_stats()
  local gs = vim.b.gitsigns_status_dict
  if not gs then
    return
  end
  local function count(typ, sign, hl)
    local c = gs[typ]
    if (c or 0) > 0 then
      return hi(string.format('Git%s', hl), string.format('%s%d', sign, c))
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
  return hi('DAP', string.format(' %s ', dap.status()))
end

local function diagnostic(severity, sign, hl)
  local c = #vim.diagnostic.get(0, {severity = severity})
  if c == 0 then
    return ''
  end
  return hi(string.format('Diagnostics%s', hl), string.format('%s%d', sign, c))
end

local function diagnostic_counts()
  return join(' ', ipairs({
    diagnostic(vim.diagnostic.severity.INFO,  '🛈 ', 'Info'),
    diagnostic(vim.diagnostic.severity.HINT,  '🛈 ', 'Hint'),
    diagnostic(vim.diagnostic.severity.WARN,  '⚠ ', 'Warn'),
    diagnostic(vim.diagnostic.severity.ERROR, ' ', 'Error'),
  }))
end

local function lsp_clients()
  return join(hi('LSPSeparator', ', '), hify('LSPName', map(function(c)
    return c.name
  end, ipairs(vim.lsp.buf_get_clients(0)))))
end

local function cursor_position()
  return hi('CursorPosition', join(':', ipairs({'%3l', '%-2c'})))
end

local function percentage()
  return hi('Percentage', '%3p%%')
end

local scroll_bar_blocks = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' }
local function scroll_bar()
  local cl = vim.api.nvim_win_get_cursor(0)[1]
  local tl = vim.api.nvim_buf_line_count(0)
  return hi('ScrollBar', string.rep(scroll_bar_blocks[math.floor(cl/tl * 7) + 1], 2))
end

return function()
  return align(ipairs({
    join(hi('Separator', ' '), ipairs({
      mode,
      git_head,
      filename,
      git_stats,
    })),
    dap_status,
    join(hi('Separator', ' '), ipairs({
      diagnostic_counts,
      lsp_clients,
      cursor_position,
      percentage,
      scroll_bar,
    }))
  }))
end
