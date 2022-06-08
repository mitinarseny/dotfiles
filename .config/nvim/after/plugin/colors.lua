vim.g.nord_bold_vertical_split_line = false
vim.g.nord_uniform_diff_background  = true

vim.cmd('packadd! nord')

vim.cmd('colorscheme nord')
-- fix: remove background highlighting of Diff* groups
for _,g in ipairs({'DiffAdd', 'DiffChange', 'DiffDelete'}) do
  vim.highlight.create(g, {ctermbg='NONE', guibg='NONE'}, false)
end

local vi_mode = require('feline.providers.vi_mode')

local cursor = {}
function cursor.position()
  return string.format('%3d:%-2d', vim.fn.line('.'), vim.fn.col('.'))
end
function cursor.line_percentage()
  local cur = vim.fn.line('.')
  local total = vim.fn.line('$')

  return string.format('%2d%%%%', vim.fn.round(cur / total * 100))
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
-- vim.cmd('packadd! nord')
-- local nord_colors = vim.fn['NordPalette']()
require('feline').setup({
  preset = 'noicon',
  components = {
    active = {
      { -- left
        {
          provider = mode.short_name,
          --hl = mode.hl,
          left_sep = {
            str = ' ',
            --hl = mode.hl,
          },
          right_sep = {
            str = ' ',
            --hl = mode.hl,
          },
        }, {
          provider = function()
            return vim.b.gitsigns_head
          end,
          enabled = function()
            return vim.b.gitsigns_head ~= nil
          end,
          left_sep = {
            str = '[',
            hl = {},
          },
          right_sep = {
            str = '] ',
            hl = {},
          },
          hl = {},
        }, {
          provider = 'file_info',
          icon = '',
          opts = {
            type = 'unique-short',
            colored_icon = false,
            file_modified_icon = '*',
            file_readonly_icon = '[RO]',
          },
        }, {
          provider = function()
            return vim.b.gitsigns_status
          end,
          enabled = function()
            return vim.b.gitsigns_status ~= nil
          end,
          left_sep = {
            str = ' (',
          },
          right_sep = {
            str = ') ',
          },
        },
      }, -- end(left)
      { -- right
        {
          provider = function() return 'i' ..
            #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.INFO}) end,
          enabled =  function() return
            #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.INFO}) > 0 end,
          left_sep = {
            str = ' ',
            hl = {bg = 'nord7'},
          },
          right_sep = {
            str = ' ',
            hl = {bg = 'nord7'},
          },
          hl = {bg = 'nord7', fg = 'nord0'},
        }, {
          provider = function() return 'H' ..
            #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.HINT}) end,
          enabled =  function() return
            #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.HINT}) > 0 end,
          left_sep = {
            str = ' ',
            hl = {bg = 'nord8'},
          },
          right_sep = {
            str = ' ',
            hl = {bg = 'nord8'},
          },
          hl = {bg = 'nord8', fg = 'nord0'},
        }, {
          provider = function() return 'W' ..
            #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.WARN}) end,
          enabled =  function() return
            #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.WARN}) > 0 end,
          left_sep = {
            str = ' ',
            hl = {bg = 'nord13'},
          },
          right_sep = {
            str = ' ',
            hl = {bg = 'nord13'},
          },
          hl = {bg = 'nord13', fg = 'nord0'},
        }, {
          provider = function() return 'E' ..
            #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.ERROR}) end,
          enabled =  function() return
            #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.ERROR}) > 0 end,
          left_sep = {
            str = ' ',
            hl = {bg = 'nord11'},
          },
          right_sep = {
            str = ' ',
            hl = {bg = 'nord11'},
          },
          hl = {bg = 'nord11'},
        }, {
          provider = function ()
            local names = {}
            for _, client in pairs(vim.lsp.buf_get_clients()) do
              names[#names+1] = client.name
            end
            return table.concat(names, ', ')
          end,
          enabled = lsp.is_attached,
          left_sep = {
            str = ' ',
            hl = {bg = 'nord3'},
          },
          right_sep = {
            str = ' ',
            hl = {bg = 'nord3'},
          },
          hl = {bg = 'nord3'},
        }, {
          provider = file.file_encoding,
          left_sep = '(',
          right_sep = ')',
        }, {
          provider = cursor.position,
          left_sep = ' ',
          right_sep = ' ',
        }, {
          provider = cursor.line_percentage,
          left_sep = ' ',
          right_sep = ' ',
        }, {
          provider = 'scroll_bar',
          left_sep = ' ',
          hl = {},
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
            hl = {bg = 'nord0', fg = 'nord3'},
          },
        },
      }, -- end(left)
      { -- right
        {
          provider = cursor.position,
          left_sep = ' ',
          right_sep = ' ',
        }, {
          provider = cursor.line_percentage,
          left_sep = ' ',
          right_sep = ' ',
        }, {
          provider = 'scroll_bar',
          left_sep = ' ',
          hl = {},
        },
      }, -- end(right)
    },
  },
  theme = {
    bg = '',
    fg = '',
    -- bg     = nord_colors['nord1'],
    -- fg     = nord_colors['nord6'],
    -- nord0  = nord_colors['nord0'],
    -- nord1  = nord_colors['nord1'],
    -- nord2  = nord_colors['nord2'],
    -- nord3  = nord_colors['nord3'],
    -- nord4  = nord_colors['nord4'],
    -- nord5  = nord_colors['nord5'],
    -- nord6  = nord_colors['nord6'],
    -- nord7  = nord_colors['nord7'],
    -- nord8  = nord_colors['nord8'],
    -- nord9  = nord_colors['nord9'],
    -- nord10 = nord_colors['nord10'],
    -- nord11 = nord_colors['nord11'],
    -- nord12 = nord_colors['nord12'],
    -- nord13 = nord_colors['nord13'],
    -- nord14 = nord_colors['nord14'],
    -- nord15 = nord_colors['nord15'],
  },
})
