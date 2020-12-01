set encoding=utf-8
scriptencoding utf-8

" ======= General ======= "
" execute local .vimrc
set exrc
" do not allow autocmd, shell and write commands in local .vimrc
set secure
" change <Leader> to comma
let mapleader = ","

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

set breakindent
set breakindentopt=sbr
let &showbreak = '~> '

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
set scrolloff=3

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
noremap  <A-Left>       b
imap     <A-Left>  <C-o><A-Left>
cnoremap <A-Left>       <S-Left>
nmap     <C-Left>       <A-Left>
imap     <C-Left>  <C-o><C-Left>
noremap  <A-Right>      e
imap     <A-Right> <ESC><A-Right>a
cnoremap <A-Right>      <S-Right>
nmap     <C-Right>      <A-Right>
imap     <C-Right> <ESC><C-Right>a

nmap <S-A-Left>  <S-C-Left>
nmap <S-A-Right> <S-C-Right>
imap <S-A-Left>  <C-o><S-C-Left>
imap <S-A-Right> <C-o><S-C-Right>
vmap <S-A-Left>  <S-C-Left>
vmap <S-A-Right> <S-C-Right>

" <Home> gets you to the first not-blank character on the line
noremap <silent> <expr> <Home> indent('.')+1 == virtcol('.') ? '0' : '^'
imap <Home>        <C-o><Home>

vnoremap <silent> <expr> <S-Home> indent('.')+1 == virtcol('.') ? '0' : '^'
nmap           <S-Home> v<S-Home>
imap       <S-Home> <C-o><S-Home>

" select until the end of line without newline character
vnoremap <S-End> g_
nmap     <S-End> v<S-End>
imap     <S-End> <C-o><S-End>

" Alt+Backspace to delete word
noremap! <A-BS> <C-w>

" delete selection with backspace
vnoremap <BS> "_d

vnoremap <Tab>   >gv
vnoremap <S-Tab> <gv

noremap <C-w>! <C-w>T

imap <C-s><Right> <C-o><C-s><Right>
imap <C-s><Left>  <C-o><C-s><Left>
imap <C-s><Down>  <C-o><C-s><Down>
imap <C-s><Up>    <C-o><C-s><Up>
imap <C-s>!       <C-o><C-s>!
imap <C-s>=       <C-o><C-s>=

tmap <C-s><Right> <C-\><C-n><C-s><Right>
tmap <C-s><Left>  <C-\><C-n><C-s><Left>
tmap <C-s><Down>  <C-\><C-n><C-s><Down>
tmap <C-s><Up>    <C-\><C-n><C-s><Up>
tmap <C-s>!       <C-\><C-n><C-s>!
tmap <C-s>=       <C-\><C-n><C-s>=

noremap <silent> <C-w>\     <Cmd>vertical          split<CR>
noremap <silent> <C-w><Bar> <Cmd>vertical botright split<CR>
noremap <silent> <C-w>-     <Cmd>                  split<CR>
noremap <silent> <C-w>_     <Cmd>         botright split<CR>

imap <C-s>\     <C-o><C-s>\
imap <C-s><Bar> <C-o><C-s><Bar>
imap <C-s>-     <C-o><C-s>-
imap <C-s>_     <C-o><C-s>_

tmap <C-s>\     <C-\><C-n><C-s>\
tmap <C-s><Bar> <C-\><C-n><C-s><Bar>
tmap <C-s>-     <C-\><C-n><C-s>-
tmap <C-s>_     <C-\><C-n><C-s>_

nnoremap <Leader>b :ls<CR>:b<Space>

" ======= UI ======= "
" set terminal title
set title

set guicursor=n-sm:block,i-ci-v-ve-c:ver25,r-cr-o:hor20

" show line numbers
set number

" highlight cursor line
set cursorline

" indentation guides for tabs
set list listchars=tab:\|\ ,trail:-

" always show sign columns
set signcolumn=yes

set noequalalways

" limit completion menu size
set pumheight=10

" directory view
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 2
let g:netrw_altv = 1
let g:netrw_winsize = 85

if has('nvim')
  function! s:on_terminal()
    setlocal signcolumn=no
    setlocal nonumber
    setlocal norelativenumber
    autocmd BufEnter,WinEnter,BufWinEnter <buffer> startinsert
    " mouse click on terminal buffer brings it to terminal mode
    nnoremap <buffer> <LeftRelease> <LeftRelease>i
    nnoremap <buffer> <Enter> <Cmd>startinsert<CR>
    startinsert
  endfunction

  augroup terminal_setup | autocmd!
    autocmd TermOpen * call <SID>on_terminal()
  augroup END
endif

runtime plugins.vim

