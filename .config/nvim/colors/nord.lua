local function hi(group, opts, default, force)
  local options = {}
  for i, k in ipairs(opts) do
    table.insert(options, tostring(k))
    table.remove(opts, i)
  end
  for k, v in pairs(opts) do
    table.insert(options, string.format('%s=%s', k, v))
  end
  vim.cmd(string.format('highlight%s%s %s %s',
    force and '!' or '',
    default and ' default' or '',
    group,
    table.concat(options, ' ')))
end

local function hi_clear(group)
  vim.cmd(string.format('highlight clear %s', group))
end

local function hi_link(from, to, force, default)
  vim.cmd(string.format('highlight%s%s link %s %s',
    force and '!' or '',
    default and ' default' or '',
    from, to))
end

vim.go.background = 'dark'
vim.go.termguicolors = false
vim.g.colors_name = 'nord'

vim.cmd([[highlight! clear]])

hi('Normal',         {ctermfg = 7})
hi('ColorColumn',    {ctermbg = 0})
hi('Conceal',        {ctermbg = 'NONE', ctermfg = 6})
hi('Cursor',         {ctermbg = 'NONE', ctermfg = 'NONE', cterm = 'reverse'})
hi('CursorColumn',   {ctermbg = 0})
hi('CursorLine',     {ctermbg = 0, cterm = 'NONE'})
hi('Directory',      {ctermfg = 12})
hi('DiffAdd',        {ctermbg = 2, ctermfg = 0})
hi('DiffChange',     {ctermbg = 11, ctermfg = 0})
hi('DiffDelete',     {ctermbg = 1, ctermfg = 0})
hi('DiffText',       {ctermbg = 11, ctermfg = 0, cterm = 'bold'})
hi('TermCursor',     {cterm = 'reverse'})
hi_clear('TermCursorNC')
hi('ErrorMsg',       {ctermbg = 1, ctermfg = 15})
hi('VertSplit',      {ctermbg = 'NONE', ctermfg = 8, cterm = 'NONE'})
hi_link('WinSeparator', 'VertSplit', true) -- TODO
hi('Folded',         {ctermbg = 0, ctermfg = 6, cterm = 'bold'})
hi_link('FoldColumn', 'SignColumn', true)
hi_link('SignColumn', 'LineNr', true)
hi('IncSearch',      {ctermbg = 13, ctermfg = 0, cterm = 'NONE'})
hi('Substitute',     {ctermbg = 11, ctermfg = 0})
hi('LineNr',         {ctermfg = 8, cterm = 'NONE'})
hi_link('LineNrAbove', 'LineNr', true)
hi_link('LineNrBelow', 'LineNr', true)
hi('CursorLineNr',   {ctermbg = 'NONE', ctermfg = 7, cterm = 'NONE'}) -- TODO
hi('CursorLineSign', {ctermbg = 'NONE', ctermfg = 7, cterm = 'NONE'})
hi('CursorLineFold', {ctermbg = 'NONE', ctermfg = 7, cterm = 'NONE'})
hi('MatchParen',     {ctermbg = 'NONE', ctermfg = 'NONE', cterm = 'bold'}) -- TODO
hi('NonText',        {ctermfg = 8})
hi_link('NormalFloat', 'Pmenu', true)
hi('Pmenu',          {ctermbg = 0, ctermfg = 'NONE'})
hi('PmenuSel',       {ctermbg = 8, ctermfg = 15})
hi('PmenuSbar',      {ctermbg = 0, ctermfg = 'NONE'})
hi('PmenuThumb',     {ctermbg = 8, ctermfg = 8})
hi('Question',       {ctermfg = 10, cterm = 'bold'})
hi('Search',         {ctermbg = 'NONE', ctermfg = 'NONE', cterm = 'reverse'}) -- TODO
hi('SpecialKey',     {ctermfg = 4})
hi('SpellBad',       {ctermbg = 'NONE', ctermfg = 1, cterm = 'italic,undercurl'})
hi('SpellCap',       {ctermbg = 'NONE', ctermfg = 3, cterm = 'italic,undercurl'})
hi('SpellLocal',     {ctermbg = 'NONE', ctermfg = 6, cterm = 'italic,undercurl'})
hi('SpellRare',      {ctermbg = 'NONE', ctermfg = 4, cterm = 'italic,undercurl'})
hi('StatusLine',     {ctermbg = 0, ctermfg = 'NONE', cterm = 'NONE'})
hi('StatusLineNC',   {ctermbg = 0, ctermfg = 'NONE', cterm = 'NONE'})
hi('TabLine',        {ctermbg = 0, ctermfg = 'NONE', cterm = 'NONE'})
hi('TabLineFill',    {ctermbg = 'NONE', ctermfg = 'NONE', cterm = 'NONE'})
hi('TabLineSel',     {ctermbg = 8, ctermfg = 'NONE', cterm = 'NONE'})
hi('Title',          {ctermbg = 'NONE', ctermfg = 2, cterm = 'bold'})
hi('Visual',         {ctermbg = 0})
hi_link('VisualNOS', 'Visual', true)
hi('WarningMsg',     {ctermfg = 11})
hi_link('Whitespace', 'NonText', true)

hi('Comment',  {ctermfg = 8})
hi('Constant', {ctermfg = 'NONE'})
hi('String',   {ctermfg = 2})
hi_link('Character', 'String', true)
hi('Number',   {ctermfg = 5})
hi('Boolean',  {ctermfg = 4})
hi_link('Float', 'Number', true)

hi('Identifier', {ctermfg = 4, cterm = 'NONE'})
hi('Function',   {ctermfg = 6, cterm = 'NONE'})

hi('Statement',   {ctermfg = 4, cterm = 'NONE'})
hi('Conditional', {ctermfg = 4, cterm = 'bold'})
hi('Repeat',      {ctermfg = 4, cterm = 'bold'})
hi('Label',       {ctermfg = 4, cterm = 'bold'})
hi_link('Operator', 'Statement', true)
hi('Keyword',     {ctermfg = 4, cterm = 'bold'})
hi('Exception',   {ctermfg = 4, cterm = 'bold'})

hi('PreProc', {ctermfg = 6, cterm = 'NONE'})
hi_link('Include', 'PreProc', true)
hi_link('Define', 'PreProc', true)
hi_link('Macro', 'PreProc', true)
hi_link('PreCondit', 'PreProc', true)

hi('Type',         {ctermfg = 4, cterm = 'bold'})
hi('StorageClass', {ctermfg = 4, cterm = 'bold,italic'})
--
hi('Special',     {ctermfg = 'NONE'})
hi('SpecialChar', {ctermfg = 11})
hi('Delimiter',   {ctermfg = 15})
hi('SpecialComment', {ctermfg = 6})
hi('Debug', {ctermfg = 1})

hi('Underlined', {ctermfg = 2, cterm = 'underline'})

hi('Error', {ctermbg = 'NONE', ctermfg = 1, cterm = 'bold,underline'})

hi('Todo', {ctermbg = 'NONE', ctermfg = 11})

hi('DiagnosticInfo',  {ctermfg = 6})
hi('DiagnosticHint',  {ctermfg = 4})
hi('DiagnosticWarn',  {ctermfg = 3})
hi('DiagnosticError', {ctermfg = 1})

local function hi_status(group, opts, ...)
  if not opts.ctermbg then
    opts.ctermbg = 0 -- from StatusLine
  end
  return hi(group, opts, ...)
end

hi_link('StatusModeN', 'StatusLine', true)
hi_link('StatusMode', 'StatusModeN', true)
hi('StatusModeV', {ctermbg = 8})
hi_link('StatusModeVL', 'StatusModeV', true)
hi_link('StatusModeVB', 'StatusModeV', true)
hi('StatusModeS', {ctermbg = 4})
hi_link('StatusModeSL', 'StatusModeS', true)
hi_link('StatusModeSB', 'StatusModeS', true)
hi('StatusModeI', {ctermbg = 6})
hi('StatusModeR', {ctermbg = 11})
hi_clear('StatusModeC')
hi('StatusModeEx', {ctermbg = 2})
hi_link('StatusModeT', 'StatusModeI', true)

for c, ctermfg in pairs({
  Head    = 8,
  Added   = 2,
  Changed = 3,
  Removed = 1,
}) do
  hi_status(string.format('StatusGit%s', c), {ctermfg = ctermfg})
end

hi_link('StatusDAP', 'ErrorMsg', true)

for c, ctermfg in pairs({
  Info  = 6,
  Hint  = 4,
  Warn  = 3,
  Error = 1,
}) do
  hi_status(string.format('StatusDiagnostics%s', c), {ctermfg = ctermfg})
end

for c, ctermfg in pairs({
  Add    = 2,
  Change = 3,
  Delete = 1,
}) do
  hi(string.format('GitSigns%sNr', c), {ctermbg = 'NONE', ctermfg = ctermfg})
end

for lvl, ctermfg in pairs({
  ERROR = 1,
  WARN  = 3,
  INFO  = 4,
  DEBUG = 1,
  TRACE = 1,
}) do
  hi(string.format('Notify%sIcon', lvl), {ctermfg = ctermfg})
  hi_link(string.format('Notify%sBorder', lvl), string.format('Notify%sIcon', lvl))
  hi_link(string.format('Notify%sTitle', lvl), string.format('Notify%sIcon', lvl))
end
