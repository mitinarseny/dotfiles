local dap = require('dap')
local vi_mode = require('feline.providers.vi_mode')

local cursor = {}
function cursor.position()
  return string.format('%3d:%-2d', vim.fn.line('.'), vim.fn.col('.'))
end
function cursor.line_percentage()
  local cur = vim.fn.line('.')
  local total = vim.fn.line('$')

  return string.format('%3d%%%%', vim.fn.round(cur / total * 100))
end

local file = {}
function file.file_type()
  return vim.bo.filetype:upper()
end
function file.file_encoding()
  local enc = (vim.bo.fenc ~= '' and vim.bo.fenc) or vim.o.enc
  return enc:upper()
end

local lsp = {}
function lsp.is_attached()
  return next(vim.lsp.buf_get_clients()) ~= nil
end

local mode = {}
function mode.short_name()
  local mode = vi_mode.get_vim_mode()
  if mode == 'NORMAL' then
    return 'N'
  elseif mode == 'INSERT' then
    return 'I'
  elseif mode == 'VISUAL' then
    return 'V'
  elseif mode == 'SELECT' then
    return 'S'
  elseif mode == 'REPLACE' then
    return 'R'
  elseif mode == 'COMMAND' then
    return 'C'
  end
  return mode
end
function mode.hl()
  local mode_colors = {
    INSERT  = {bg = 'nord8', fg = 'nord0'},
    VISUAL  = {bg = 'nord7', fg = 'nord0'},
    COMMAND = {bg = 'nord10'}
  }
  return mode_colors[vi_mode.get_vim_mode()] or {}
end

vim.o.showmode = false
vim.o.termguicolors = true

local lsp_status = require('lsp-status')
-- vim.cmd('packadd! nord')
-- local nord_colors = vim.fn['NordPalette']()
require('feline').setup({
  components = {
    active = {
      { -- left
        {
          provider = mode.short_name,
        }, {
          provider = function()
            return vim.b.gitsigns_head
          end,
          enabled = function()
            return vim.b.gitsigns_head ~= nil
          end,
          hl = 'Comment',
          left_sep = {{str = ' ', hl = {}},{str = '[', hl = 'Comment'}},
          right_sep = {str = ']', hl = 'Comment'},
        }, {
          provider = 'file_info',
          icon = '',
          opts = {
            type = 'unique-short',
            colored_icon = false,
            file_modified_icon = '*',
            file_readonly_icon = '[RO]',
          },
          left_sep = {str = ' ', hl = {}},
        }, {
          provider = function()
            return '+'..(vim.b.gitsigns_status_dict or {}).added
          end,
          enabled = function()
            return ((vim.b.gitsigns_status_dict or {}).added or 0) > 0
          end,
          hl = 'GitSignsAdd',
          left_sep = {str = ' ', hl = 'GitSignsAdd'},
        }, {
          provider = function()
            return '~'..(vim.b.gitsigns_status_dict or {}).changed
          end,
          enabled = function()
            return ((vim.b.gitsigns_status_dict or {}).changed or 0) > 0
          end,
          hl = 'GitSignsChange',
          left_sep = {str = ' ', hl = 'GitSignsChange'},
        }, {
          provider = function()
            return '-'..(vim.b.gitsigns_status_dict or {}).removed
          end,
          enabled = function()
            return ((vim.b.gitsigns_status_dict or {}).removed or 0) > 0
          end,
          hl = 'GitSignsDelete',
          left_sep = {str = ' ', hl = 'GitSignsDelete'},
        },
      }, -- end(left)
      { -- center
        {
          provider = dap.status,
          enabled = function()
            return dap.session() ~= nil
          end,
          hl = 'ErrorMsg',
          left_sep = {str = ' ', hl = 'ErrorMsg'},
          right_sep = {str = ' ', hl = 'ErrorMsg'},
        },
        {hl = {}},
      }, -- end(center)
      { -- right
        {
          provider = function() return 'i' ..
            #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.INFO}) end,
          update = {'DiagnosticChanged'},
          enabled =  function() return
            #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.INFO}) > 0 end,
          hl = 'DiagnosticSignInfo',
          left_sep = {str = ' ', hl = 'DiagnosticSignInfo'},
          right_sep = {str = ' ', hl = 'DiagnosticSignInfo'},
        }, {
          provider = function() return 'H' ..
            #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.HINT}) end,
          update = {'DiagnosticChanged'},
          enabled =  function() return
            #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.HINT}) > 0 end,
          hl = 'DiagnosticSignHint',
          left_sep = {str = ' ', hl = 'DiagnosticSignInfo'},
          right_sep = {str = ' ', hl = 'DiagnosticSignInfo'},
        }, {
          provider = function() return 'W' ..
            #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.WARN}) end,
          update = {'DiagnosticChanged'},
          enabled =  function() return
            #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.WARN}) > 0 end,
          hl = 'DiagnosticSignWarn',          
          left_sep = {str = ' ', hl = 'DiagnosticSignInfo'},
          right_sep = {str = ' ', hl = 'DiagnosticSignInfo'},
        }, {
          provider = function() return 'E' ..
            #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.ERROR}) end,
          update = {'DiagnosticChanged'},
          enabled =  function() return
            #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.ERROR}) > 0 end,
          hl = 'DiagnosticSignError',
          left_sep = {str = ' ', hl = 'DiagnosticSignInfo'},
          right_sep = {str = ' ', hl = 'DiagnosticSignInfo'},
        }, {
          provider = function ()
            local names = {}
            for _, client in pairs(vim.lsp.buf_get_clients()) do
              names[#names+1] = client.name
            end
            return table.concat(names, ', ')
          end,
          -- TODO: LspAttach, LspDetach
          update = {'LspProgressUpdate', 'LspRequest'},
          enabled = lsp.is_attached,
          left_sep = {str = ' ', hl = {}},
        }, {
          provider = cursor.position,
          right_sep = {str = ' ', hl = 'StatusLineNC'},
          hl = 'StatusLineNC',
        }, {
          provider = cursor.line_percentage,
          right_sep = {str = ' ', hl = 'StatusLineNC'},
          hl = 'StatusLineNC',
        }, {
          provider = 'scroll_bar',
          hl = 'StatusLineNC',
        },
      }, -- end(right)
    },
    inactive = {
      { -- left
        {
          provider = 'file_info',
          icon = '',
          opts = {
            type = 'unique-short',
            colored_icon = false,
            file_modified_icon = '*',
            file_readonly_icon = '[RO]',
          },
          left_sep = {str = ' ', hl = {}},
        },
      }, -- end(left)
      { -- right
        {
          provider = cursor.position,
          right_sep = {str = ' ', hl = 'StatusLineNC'},
        }, {
          provider = cursor.line_percentage,
          right_sep = {str = ' ', hl = 'StatusLineNC'},
        }, {
          provider = 'scroll_bar',
          hl = 'StatusLineNC',
        },
      }, -- end(right)
    },
  },
  theme = { bg = '', fg = '' }, -- inherit
})
