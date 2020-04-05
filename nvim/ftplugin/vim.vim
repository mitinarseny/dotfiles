setlocal tabstop=2 softtabstop=2 expandtab shiftwidth=2

" https://github.com/jiangmiao/auto-pairs/issues/272#issuecomment-583102709
if has_key(g:AutoPairs, '"')
  let b:AutoPairs = copy(g:AutoPairs)
  call remove(b:AutoPairs, '"')
endif

if executable('vim-language-server')
  augroup LspVim
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
      \ 'name': 'vim-language-server',
      \ 'cmd': {server_info->['vim-language-server', '--stdio']},
      \ 'whitelist': ['vim'],
      \ 'initialization_options': {
      \   'vimruntime': $VIMRUNTIME,
      \   'runtimepath': &rtp,
      \ }})
  augroup END
endif

