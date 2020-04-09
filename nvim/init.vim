set encoding=utf-8
scriptencoding utf-8

runtime plugins.vim

" ======= General ======= "
" use system clipboard
set clipboard+=unnamedplus

"do not unload buffer when it is abandoned
set hidden

" enable mouse everywhene
set mouse=a

" enable syntax highlighting if terminal supports colors
if &t_Co > 1
  syntax enable
endif

" disable bells 
set noerrorbells
set novisualbell

" ignore case in search patterns
set ignorecase

" write more frequently
set updatetime=100

" read changes outside of vim
set autoread

" keep more lines above and below cursor when scrolling
set scrolloff=5

" wrap long lines 
set wrap

" allow <Left> and <Right> move to next/previous line 
set whichwrap=<,>,[,]

" enable command-line completion
set wildmenu
set wildignore=*.o,*~,*.pyc
if has('win16') || has('win32')
  set wildignore+=.git\*,.hg\*,.svn\*
else
  set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

" do not make backups before writing to file
set nobackup
set nowritebackup
set noswapfile

" ======= Editing ======= "
" tabulation
set smarttab
set shiftwidth=4
set tabstop=4
set autoindent
set smartindent

" enable arrows to select text
set keymodel=startsel,stopsel

" set complete options
set completeopt=menu,menuone,noinsert

" do not show insert completion popups 
set shortmess+=c

" redo last undone change with U
noremap U <C-r>

" jump by words with Alt/Ctrl + arrows
noremap <A-Left>       b
imap    <A-Left>  <C-o><A-Left>
nmap    <C-Left>       <A-Left>
imap    <C-Left>  <C-o><C-Left>
noremap <A-Right>      e
imap    <A-Right> <ESC><A-Right>a
nmap    <C-Right>      <A-Right>
imap    <C-Right> <ESC><C-Right>a

nmap <S-A-Left>  <S-C-Left>
nmap <S-A-Right> <S-C-Right>
imap <S-A-Left>  <C-o><S-C-Left>
imap <S-A-Right> <C-o><S-C-Right>
vmap <S-A-Left>  <S-C-Left>
vmap <S-A-Right> <S-C-Right>

" <Home> gets you to the first not-blank character on the line
noremap <silent> <expr> <Home> indent('.')+1 == virtcol('.') ? '0' : '^'
imap <silent> <Home>   <C-o><Home>

vnoremap <silent> <expr> <S-Home> indent('.')+1 == virtcol('.') ? '0' : '^'
nmap <silent> <S-Home> v<S-Home>
imap <silent> <S-Home> <C-o><S-Home>

" select until the end of line without newline character
vnoremap <S-End> g_
nmap     <S-End> v<S-End>
imap     <S-End> <C-o><S-End>

" Alt+Backspace to delete word
noremap <A-BS> "_db
noremap <C-BS> <A-BS>
imap <A-BS> <C-o><A-BS>

" delete selection with backspace
vnoremap <BS> "_d

" ======= UI ======= "
" set terminal title
set title

" show line numbers
set number

" highlight cursor line
set cursorline

" indentation guides for tabs
set list listchars=tab:\|\ 

" always show sign columns
set signcolumn=yes

" directory view
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25

augroup TerminalStuff
  autocmd!
  autocmd TermOpen * setlocal
    \ signcolumn=no
    \ nonumber
    \ norelativenumber 
    \ | startinsert
augroup END

