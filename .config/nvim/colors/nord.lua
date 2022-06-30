local function hi(name, opts)
  return vim.api.nvim_set_hl(0, name, opts)
end

vim.go.background = 'dark'
vim.go.termguicolors = false
vim.g.colors_name = 'nord'

vim.cmd([[highlight! clear]])

for g, opts in pairs({
  Normal = {ctermfg = 7},
  ColorColumn = {ctermbg = 0},
  Conceal = {ctermbg = 'NONE', ctermfg = 6},
  Cursor = {ctermbg = 'NONE', ctermfg = 'NONE', cterm = {reverse = true}},
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
  VertSplit = {ctermbg = 'NONE', ctermfg = 8},
  WinSeparator = {link = 'VertSplit'},
  Folded = {ctermbg = 0, ctermfg = 6, cterm = {bold = true}},
  FoldColumn = {link = 'SignColumn'},
  SignColumn = {link = 'LineNr'},
  IncSearch = {ctermbg = 13, ctermfg = 0},
  Substitute = {ctermbg = 11, ctermfg = 0},
  LineNr = {ctermfg = 8},
  LineNrAbove = {link = 'LineNr'},
  LineNrBelow = {link = 'LineNr'},
  CursorLineNr = {ctermbg = 'NONE', ctermfg = 7}, -- TODO
  CursorLineSign = {ctermbg = 'NONE', ctermfg = 7},
  CursorLineFold = {ctermbg = 'NONE', ctermfg = 7},
  MatchParen = {ctermbg = 'NONE', ctermfg = 'NONE', cterm = {bold = true}}, -- TODO
  NonText = {ctermfg = 8},
  NormalFloat = {link = 'Pmenu'},
  Pmenu = {ctermbg = 0, ctermfg = 'NONE'},
  PmenuSel = {ctermbg = 8, ctermfg = 15},
  PmenuSbar = {ctermbg = 0, ctermfg = 'NONE'},
  PmenuThumb = {ctermbg = 8, ctermfg = 8},
  Question = {ctermfg = 10, cterm = {bold = true}},
  Search = {ctermbg = 'NONE', ctermfg = 'NONE', cterm = {reverse = true}}, -- TODO
  SpecialKey = {ctermfg = 4},
  SpellBad = {ctermbg = 'NONE', ctermfg = 1, cterm = {italic = true, undercurl = true}},
  SpellCap = {ctermbg = 'NONE', ctermfg = 3, cterm = {italic = true, undercurl = true}},
  SpellLocal = {ctermbg = 'NONE', ctermfg = 6, cterm = {italic = true, undercurl = true}},
  SpellRare = {ctermbg = 'NONE', ctermfg = 4, cterm = {italic = true, undercurl = true}},
  StatusLine = {ctermbg = 0, ctermfg = 'NONE'},
  StatusLineNC = {ctermbg = 'NONE', ctermfg = 'NONE'},
  TabLine = {ctermbg = 0, ctermfg = 'NONE'},
  TabLineFill = {ctermbg = 'NONE', ctermfg = 'NONE'},
  TabLineSel = {ctermbg = 8, ctermfg = 'NONE'},
  Title = {ctermbg = 'NONE', ctermfg = 2, cterm = {bold = true}},
  Visual = {ctermbg = 0},
  VisualNOS = {link = 'Visual'},
  WarningMsg = {ctermfg = 11},
  Whitespace = {link = 'NonText'},

  Comment = {ctermfg = 8},
  Constant = {ctermfg = 'NONE'},
  String = {ctermfg = 2},
  Character = {link = 'String'},
  Number = {ctermfg = 5},
  Boolean = {ctermfg = 4},
  Float = {link = 'Number'},

  Identifier = {ctermfg = 4},
  Function = {ctermfg = 6},

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
  StorageClass = {ctermfg = 4, cterm = {bold = true, italic = true}},
  --
  Special = {ctermfg = 'NONE'},
  SpecialChar = {ctermfg = 11},
  Delimiter = {ctermfg = 15},
  SpecialComment = {ctermfg = 6},
  Debug = {ctermfg = 1},

  Underlined = {ctermfg = 2, cterm = {underline = true}},

  Error = {ctermbg = 'NONE', ctermfg = 1, cterm = {bold = true, underline = true}},

  Todo = {ctermbg = 'NONE', ctermfg = 11},

  DiagnosticInfo = {ctermfg = 6},
  DiagnosticHint = {ctermfg = 4},
  DiagnosticWarn = {ctermfg = 3},
  DiagnosticError = {ctermfg = 1},

  LspReferenceText = {ctermbg = 0},

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
  LSPIndicatorWorking = {ctermfg = 4},

  DiagnosticsInfo  = {ctermfg = 6},
  DiagnosticsHint  = {ctermfg = 4},
  DiagnosticsWarn  = {ctermfg = 3},
  DiagnosticsError = {ctermfg = 1},
}) do
  opts = opts or {}
  if next(opts) == nil then
    opts.link = 'StatusLine'
  elseif not opts.ctermbg then
    opts.ctermbg = 0 -- from StatusLine
  end
  hi('Status'..g, opts)
end
