local function hi(name, opts)
  local inherit = opts.inherit
  opts.inherit = nil
  if inherit ~= nil then
    local inh = vim.api.nvim_get_hl_by_name(inherit, false)
    opts.ctermbg = opts.ctermbg or inh.background
    inh.background = nil
    opts.ctermfg = opts.ctermfg or inh.foreground
    inh.foreground = nil
    opts.cterm = vim.tbl_extend('keep', opts.cterm or {}, inh)
  end
  return vim.api.nvim_set_hl(0, name, opts)
end

vim.go.background = 'dark'
vim.go.termguicolors = false
vim.g.colors_name = 'nord'

vim.cmd([[highlight! clear]])

for g, opts in pairs({
  Normal = {ctermfg = 7},
  ColorColumn = {ctermbg = 0},
  Conceal = {ctermfg = 6},
  Cursor = {cterm = {reverse = true}},
  CursorColumn = {ctermbg = 0},
  CursorLine = {ctermbg = 0},
  Directory = {ctermfg = 12},
  DiffAdd = {ctermbg = 2, ctermfg = 0},
  DiffChange = {ctermbg = 11, ctermfg = 0},
  DiffDelete = {ctermbg = 1, ctermfg = 0},
  DiffText = {ctermbg = 11, ctermfg = 0, cterm = {bold = true}},
  TermCursor = {cterm = {reverse = true}},
  TermCursorNC = {},
  ErrorMsg = {ctermbg = 1, ctermfg = 15},
  VertSplit = {ctermfg = 8},
  WinSeparator = {link = 'VertSplit'},
  Folded = {ctermbg = 0, ctermfg = 6, cterm = {bold = true}},
  FoldColumn = {link = 'SignColumn'},
  SignColumn = {link = 'LineNr'},
  IncSearch = {ctermbg = 13, ctermfg = 0},
  Substitute = {ctermbg = 11, ctermfg = 0},
  LineNr = {ctermfg = 8},
  LineNrAbove = {link = 'LineNr'},
  LineNrBelow = {link = 'LineNr'},
  CursorLineNr = {ctermfg = 7}, -- TODO
  CursorLineSign = {ctermfg = 7},
  CursorLineFold = {ctermfg = 7},
  MatchParen = {cterm = {bold = true}}, -- TODO
  NonText = {ctermfg = 8},
  NormalFloat = {link = 'Pmenu'},
  Pmenu = {ctermbg = 0, },
  PmenuSel = {ctermbg = 8, ctermfg = 15},
  PmenuSbar = {ctermbg = 0, },
  PmenuThumb = {ctermbg = 8, ctermfg = 8},
  Question = {ctermfg = 10, cterm = {bold = true}},
  Search = {cterm = {reverse = true}}, -- TODO
  SpecialKey = {ctermfg = 4},
  SpellBad = {ctermfg = 1, cterm = {italic = true, undercurl = true}},
  SpellCap = {ctermfg = 3, cterm = {italic = true, undercurl = true}},
  SpellLocal = {ctermfg = 6, cterm = {italic = true, undercurl = true}},
  SpellRare = {ctermfg = 4, cterm = {italic = true, undercurl = true}},
  StatusLine = {ctermbg = 0},
  StatusLineNC = {},
  TabLine = {ctermbg = 0},
  TabLineFill = {},
  TabLineSel = {ctermbg = 8},
  Title = {ctermfg = 2, cterm = {bold = true}},
  Visual = {ctermbg = 0},
  VisualNOS = {link = 'Visual'},
  WarningMsg = {ctermfg = 11},
  Whitespace = {link = 'NonText'},

  Comment = {ctermfg = 8},
  Constant = {},
  String = {ctermfg = 2},
  Character = {link = 'String'},
  Number = {ctermfg = 5},
  Boolean = {ctermfg = 4},
  Float = {link = 'Number'},

  Identifier = {ctermfg = 4},
  Function = {ctermfg = 6},
  Method = {ctermfg = 4},

  Statement = {ctermfg = 4},
  Conditional = {ctermfg = 4, cterm = {bold = true}},
  Repeat = {ctermfg = 4, cterm = {bold = true}},
  Label = {ctermfg = 4, cterm = {bold = true}},
  Operator = {link = 'Statement'},
  Keyword = {ctermfg = 4, cterm = {bold = true}},
  Exception = {ctermfg = 4, cterm = {bold = true}},

  PreProc = {ctermfg = 6},
  Include = {link = 'PreProc'},
  Define = {link = 'PreProc'},
  Macro = {link = 'PreProc'},
  PreCondit = {link = 'PreProc'},

  Type = {ctermfg = 4, cterm = {bold = true}},
  Class = {link = 'Type'},
  StorageClass = {ctermfg = 4, cterm = {bold = true, italic = true}},
  --
  Special = {},
  SpecialChar = {ctermfg = 11},
  Delimiter = {ctermfg = 15},
  SpecialComment = {ctermfg = 6},
  Debug = {ctermfg = 1},

  Underlined = {ctermfg = 2, cterm = {underline = true}},

  Error = {ctermfg = 1, cterm = {bold = true, underline = true}},

  Todo = {ctermfg = 11},

  DiagnosticInfo = {ctermfg = 6},
  DiagnosticHint = {ctermfg = 4},
  DiagnosticWarn = {ctermfg = 3},
  DiagnosticError = {ctermfg = 1},

  LspReferenceText = {ctermbg = 0},
  LspReferenceRead = {link = 'LspReferenceText'},
  LspReferenceWrite = {link = 'LspReferenceText'},

  GitSignsAddNr    = {ctermfg = 2},
  GitSignsChangeNr = {ctermfg = 3},
  GitSignsDeleteNr = {ctermfg = 1},

  TelescopeBorder   = {link = 'Comment'},
  TelescopeTitle    = {link = 'Normal'},
  TelescopeMatching = {link = 'String'},

  NotifyERRORIcon   = {ctermfg = 1},
  NotifyERRORBorder = {link = 'NotifyERRORIcon'},
  NotifyERRORTitle  = {link = 'NotifyERRORIcon'},
  NotifyWARNIcon    = {ctermfg = 3},
  NotifyWARNBorder  = {link = 'NotifyWARNIcon'},
  NotifyWARNTitle   = {link = 'NotifyWARNIcon'},
  NotifyINFOIcon    = {ctermfg = 4},
  NotifyINFOBorder  = {link = 'NotifyINFOIcon'},
  NotifyINFOTitle   = {link = 'NotifyINFOIcon'},
  NotifyDEBUGIcon   = {ctermfg = 1},
  NotifyDEBUGBorder = {link = 'NotifyDEBUGIcon'},
  NotifyDEBUGTitle  = {link = 'NotifyDEBUGIcon'},
  NotifyTRACEIcon   = {ctermfg = 1},
  NotifyTRACEBorder = {link = 'NotifyTRACEIcon'},
  NotifyTRACETitle  = {link = 'NotifyTRACEIcon'},

  CmpItemMenu = {ctermfg = 8},
  CmpItemKindMethod = {link = 'Method'},
  CmpItemKindFunction = {link = 'Function'},
  CmpItemKindConstructor = {link = 'Method'},
  CmpItemKindField = {link = 'Identifier'},
  CmpItemKindVariable = {link = 'Identifier'},
  CmpItemKindClass = {link = 'Class'},
  CmpItemKindInterface = {link = 'Class'},
  CmpItemKindModule = {link = 'Class'},
  CmpItemKindProperty = {link = 'Function'},
  CmpItemKindUnit = {link = 'Class'},
  CmpItemKindValue = {link = 'Constant'},
  CmpItemKindEnum = {link = 'Class'},
  CmpItemKindKeyword = {link = 'Keyword'},
  CmpItemKindSnippet = {link = 'String'},
  CmpItemKindColor = {link = 'Special'},
  CmpItemKindFile = {ctermfg = 6},
  CmpItemKindReference = {link = 'Identifier'},
  CmpItemKindFolder = {ctermfg = 6},
  CmpItemKindEnumMember = {link = 'Identifier'},
  CmpItemKindConstant = {link = 'Constant'},
  CmpItemKindStruct = {link = 'Class'},
  CmpItemKindEvent = {link = 'Identifier'},
  CmpItemKindOperator = {link = 'Operator'},
  CmpItemKindTypeParameter = {link = 'Type'},
}) do
  hi(g, opts)
end

for g, opts in pairs({
  Separator = {},

  ModeN  = {},
  Mode   = {link = 'StatusModeN'},
  ModeV  = {ctermbg = 8},
  ModeVL = {link = 'StatusModeV'},
  ModeVB = {link = 'StatusModeV'},
  ModeS  = {ctermbg = 4},
  ModeSL = {link = 'StatusModeS'},
  ModeSB = {link = 'StatusModeS'},
  ModeI  = {ctermbg = 6},
  ModeR  = {ctermbg = 11},
  ModeC  = {link = 'StatusModeN'},
  ModeEx = {ctermbg = 2},
  ModeT  = {link = 'StatusModeI'},

  FileName       = {},
  CursorPosition = {},
  Percentage     = {},
  ScrollBar      = {},

  GitHead    = {ctermfg = 8},
  GitAdded   = {ctermfg = 2},
  GitChanged = {ctermfg = 3},
  GitRemoved = {ctermfg = 1},

  DAP = {link = 'ErrorMsg'},

  LSPIndicator        = {ctermfg = 8},
  LSPIndicatorWorking = {ctermfg = 5},

  DiagnosticsInfo  = {ctermfg = 6},
  DiagnosticsHint  = {ctermfg = 4},
  DiagnosticsWarn  = {ctermfg = 3},
  DiagnosticsError = {ctermfg = 1},
}) do
  hi('Status'..g, vim.tbl_extend('keep', opts or {}, {inherit = 'StatusLine'}))
end
