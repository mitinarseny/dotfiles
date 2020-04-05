setlocal tabstop=2 softtabstop=2 shiftwidth=2

" https://github.com/jiangmiao/auto-pairs/issues/272#issuecomment-583102709
if has_key(g:AutoPairs, '"')
  let b:AutoPairs = copy(g:AutoPairs)
  call remove(b:AutoPairs, '"')
endif
