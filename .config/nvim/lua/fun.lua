local M = {}

function M.map(f, gen, ...)
  return function(...)
    local k, v = gen(...)
    if k then
      return k, f(k, v)
    end
  end, ...
end

function M.filter(f, gen, ...)
  return function(state, k)
    local v
    repeat
      k, v = gen(state, k)
    until not k or f(k, v)
    return k, v
  end, ...
end

function M.collect(...)
  local t = {}
  for k, v in ... do
    t[k] = v
  end
  return t
end

function M.icollect(...)
  local t = {}
  for _, v in ... do
    table.insert(t, v)
  end
  return t
end

return M
