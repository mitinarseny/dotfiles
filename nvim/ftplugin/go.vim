if executable('gopls')
  let b:ale_linters = ['gopls']

  augroup LspGo
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
      \ 'name': 'gopls',
      \ 'cmd': {server_info->['gopls']},
      \ 'whitelist': ['go'],
      \ })
    autocmd BufWritePre *.go LspDocumentFormatSync
  augroup END
endif

