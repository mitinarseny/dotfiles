set encoding=utf-8
scriptencoding utf-8


source ~/.config/nvim/plugins.vim

set noshowmode
let g:lightline = {
  \   'colorscheme': 'nord',
  \   'active': {
  \     'left': [
  \       ['mode', 'paste'],
  \       ['gitbranch', 'filename'],
  \      ],
  \      'right': [
  \        ['lineinfo'],
  \        ['percent'],
  \        ['readonly', 'linter_checking', 'linter_errors', 'linter_wanrings', 'linter_ok'],
  \      ], 
  \   },
  \   'component': {
  \     'lineinfo': '☰ %3l:%-2v',
  \   },
  \   'component_expand': {
  \     'readonly': 'LightlineReadonly',
  \     'linter_checking': 'lightline#ale#checking',
  \     'linter_wanrings': 'lightline#ale#warnings',
  \     'linter_errors': 'lightline#ale#errors',
  \     'linter_ok': 'lightline#ale#ok',
  \   },
  \   'component_type': {
  \     'readonly': 'error',
  \     'linter_checking': 'left',
  \     'linter_wanrings': 'warning',
  \     'linter_errors': 'error',
  \     'linter_ok': 'left',
  \   },
  \   'component_function': {
  \     'gitbranch': 'LightlineFugitive',
  \     'filename': 'LightlineFileName',
  \     'fileformat': 'LightlineFileformat',
  \     'filetype': 'LightlineFiletype',
  \   },
  \   'separator': { 'left': '', 'right': '' },
  \   'subseparator': { 'left': '|', 'right': '|' }
  \ }

function! LightlineFileName()
  let filename = expand('%:t')
  if filename ==# ''
    let filename = '[No Name]'
  endif
  let modified = &modified ? ' +' : ''
  return filename . modified
endfunction

function! LightlineReadonly()
  return &readonly && &filetype !~# '\v(help|vimfiler|unite)' ? 'RO' : ''
endfunction

function! LightlineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightlineFiletype()
  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! LightlineFugitive()
  if &filetype !~? 'vimfiler' && exists('*fugitive#head')
    return fugitive#head()
  endif
  return ''
endfunction

" function! LightlineLinterWarnings() abort
"   let l:counts = ale#statusline#Count(bufnr(''))
"   let l:all_errors = l:counts.error + l:counts.style_error
"   let l:all_non_errors = l:counts.total - l:all_errors
"   return l:counts.total == 0 ? '' : printf('%d ◆', all_non_errors)
" endfunction
"
" function! LightlineLinterErrors() abort
"   let l:counts = ale#statusline#Count(bufnr(''))
"   let l:all_errors = l:counts.error + l:counts.style_error
"   let l:all_non_errors = l:counts.total - l:all_errors
"   return l:counts.total == 0 ? '' : printf('%d ✗', all_errors)
" endfunction
"
" function! LightlineLinterOK() abort
"   let l:counts = ale#statusline#Count(bufnr(''))
"   let l:all_errors = l:counts.error + l:counts.style_error
"   let l:all_non_errors = l:counts.total - l:all_errors
"   return l:counts.total == 0 ? '✓ ' : ''
" endfunction
"
" augroup LightLineOnALE
"   autocmd!
"   autocmd User ALEFixPre   call lightline#update()
"   autocmd User ALEFixPost  call lightline#update()
"   autocmd User ALELintPre  call lightline#update()
"   autocmd User ALELintPost call lightline#update()
" augroup end

"if has('win32')
"  "function Comment
"  imap <C-/> <esc>\c<space><CR>i
"  vmap <C-/> \c<space>gv
"else
"  imap <C-_> <esc>\c<space><CR>i
"  vmap <C-_> \c<space>gv
"endif
"let g:NERDDefaultAlign = 'left'


"call deoplete#custom#option('omni_patterns', { 'go': '[^.*\t]\.\w*' })
set ignorecase
set noerrorbells
set novisualbell
syntax enable
set updatetime=100
set scrolloff=7
set nobackup
set nowritebackup
set noswapfile
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4
set autoindent
set smartindent
set wrap

set wildmenu
set wildignore=*.o,*~,*.pyc
if has('win16') || has('win32')
  set wildignore+=.git\*,.hg\*,.svn\*
else
  set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif
set whichwrap=<,>

set autoread
set number
set cursorline
set mouse=a

set keymodel=startsel,stopsel

let g:nord_cursor_line_number_background = 1
let g:nord_bold_vertical_split_line = 1
let g:nord_uniform_diff_background = 1

colorscheme nord

let g:ale_lint_on_text_changed='always'

"augroup TerminalStuff
   "au!
  "autocmd TermOpen * setlocal nonumber norelativenumber | startinsert
"augroup END

"set hidden
"set nobackup
"set nowritebackup
"set cmdheight=2
"set updatetime=300
"set shortmess
"set signcolumn=yes
"inoremap <silent><expr> <TAB>
      "\ pumvisible() ? "\<C-n>" :
      "\ <SID>check_back_space() ? "\<TAB>" :
      "\ coc#refresh()
"inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
"function! s:check_back_space() abort
  "let col = col('.') - 1
  "return !col || getline('.')[col - 1]  =~# '\s'
"endfunction
"inoremap <silent><expr> <c-space> coc#refresh()
set hidden

set signcolumn=yes
set completeopt=menu,menuone,preview,noselect,noinsert
set shortmess+=c
