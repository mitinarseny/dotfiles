vim.diagnostic.config({
  underline = true,
  virtual_text = {
    source = 'if_many',
    prefix = '●',
  },
  signs = true,
  update_in_insert = true,
  severity_sort = true,
})

for name, sign in pairs({
  Error = '',
  Warn  = '⚠',
  Info  = '🛈',
  Hint  = '🛈',
}) do
  name = string.format('DiagnosticSign%s', name)
  vim.fn.sign_define(name, {text = sign, texthl = name})
end
