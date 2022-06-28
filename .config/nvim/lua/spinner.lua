local notify = require('notify')

local Spinner = {}
Spinner.__index = Spinner
setmetatable(Spinner, {
  __call = function(cls, ...)
    return cls.new(...)
  end,
})

local spinner_frames = { '⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷' }

function Spinner.new(msg, lvl, opts)
  local self = setmetatable({}, Spinner)

  opts = opts or {}
  opts.timeout = false
  self:_spin(msg, lvl, opts)

  self.timer = vim.loop.new_timer()
  self.timer:start(0, 1000/#spinner_frames, vim.schedule_wrap(function()
    self:_spin()
  end))

  return self
end

function Spinner:update(msg, lvl, opts)
  opts = opts or {}
  opts.replace = self.id
  opts.hide_from_history = true
  self.id = notify(msg, lvl, opts)
  vim.api.nvim_command('redraw')
end

function Spinner:_spin(msg, lvl, opts)
  opts = opts or {}
  if opts.icon == nil then
    self.frame = (self.frame or 0) % #spinner_frames + 1
    opts.icon = spinner_frames[self.frame]
  end
  return self:update(msg, lvl, opts)
end

function Spinner:done(msg, lvl, opts)
  self.timer:close()
  opts = opts or {}
  if opts.timeout == nil then
    opts.timeout = 3000
  end
  return self:update(msg, lvl, opts)
end

return Spinner
