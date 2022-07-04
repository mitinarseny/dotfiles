local M = {}

function M.map(f, gen, ...)
  assert(type(f) == 'function' and type(gen) == 'function')
  return function(...)
    local k, v = gen(...)
    if k then
      return k, f(k, v)
    end
  end, ...
end

function M.filter(f, gen, ...)
  assert(type(f) == 'function' and type(gen) == 'function')
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

function M.any(...)
  for _, v in ... do
    if v then
      return true
    end
  end
  return false
end

function M.all(...)
  for _, v in ... do
    if not v then
      return false
    end
  end
  return true
end

return M
