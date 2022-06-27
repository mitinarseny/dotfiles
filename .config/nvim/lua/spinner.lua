local client_notifs = {}

local Spinner = {}

function Spinner:_get(id, token)
  if not self[id] then
    self[id] = {}
  end
  if not self[id][token] then
    self[id][token] = {}
  end
end

function Spinner:redraw(id, token)
  
end

local function new()
  
end

local M = {}

M.new = function()

end

local function get_notif_data(client_id, token)
 if not client_notifs[client_id] then
   client_notifs[client_id] = {}
 end

 if not client_notifs[client_id][token] then
   client_notifs[client_id][token] = {}
 end

 return client_notifs[client_id][token]
end


local spinner_frames = { '⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷' }

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
 return client_name .. (#title > 0 and ': ' .. title or '')
end

local function format_message(message, percentage)
 return (percentage and percentage .. '%\t' or '') .. (message or '')
end

return M
