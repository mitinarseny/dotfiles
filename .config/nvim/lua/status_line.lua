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
  return string.format('%%#%s#%s%%*', group, text)
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
  return hi(string.format('StatusMode%s', mode_hi[vim.fn.mode()] or ''), ' ')
end

local function git_head()
  local h = vim.b.gitsigns_head
  return h and hi('StatusGitHead', string.format('[%s]', h) or '')
end

local function git_stats()
  local gs = vim.b.gitsigns_status_dict
  if not gs then
    return
  end
  local function count(typ, sign, hl)
    local c = gs[typ]
    if (c or 0) > 0 then
      return hi(string.format('StatusGit%s', hl), string.format('%s%d', sign, c))
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
  return hi('StatusDAP', string.format(' %s ', dap.status()))
end

local function diagnostics(severity, sign, hl)
  local c = #vim.diagnostic.get(0, {severity = severity})
  if c == 0 then
    return ''
  end
  return hi(string.format('StatusDiagnostics%s', hl), string.format('%s%d', sign, c))
end

local scroll_bar_blocks = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' }

local function scroll_bar()
  local cl = vim.api.nvim_win_get_cursor(0)[1]
  local tl = vim.api.nvim_buf_line_count(0)
  return string.rep(scroll_bar_blocks[math.floor(cl/tl * 7) + 1], 2)
end

return function()
  return align(ipairs({
    join(' ', ipairs({
      mode,
      git_head,
      '%t',
      git_stats,
    })),
    dap_status,
    join(' ', ipairs({
      join(' ', ipairs({
        diagnostics(vim.diagnostic.severity.INFO,  '🛈 ', 'Info'),
        diagnostics(vim.diagnostic.severity.HINT,  '🛈 ', 'Hint'),
        diagnostics(vim.diagnostic.severity.WARN,  '⚠ ', 'Warn'),
        diagnostics(vim.diagnostic.severity.ERROR, ' ', 'Error'),
      })),
      join(':', ipairs({'%3l', '%-2c'})),
      '%3p%%',
      scroll_bar,
    }))
  }))
end
