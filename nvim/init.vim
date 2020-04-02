set encoding=utf-8
scriptencoding utf-8
" TODO: alt + left/right move by word left/right
" TODO: highlight usages of object under cursor
" TODO: select first item when use autocompletion to use only Enter
" TODO: spellcheck
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

" ======= Editing ======= "
" move around wrapped lines
noremap <silent> <Up>   gk
noremap <silent> <Down> gj

" tabulation
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4
set autoindent
set smartindent

" enable arrows to select text
set keymodel=startsel,stopsel

" do not make backups before writing to file
set nobackup
set nowritebackup
set noswapfile

" set complete options
set completeopt=menu,menuone,preview,noinsert

" do not show insert completion popups 
set shortmess+=c

" ======= UI ======= "
" set terminal title
set title

" show line numbers
set number

" highlight cursor line
set cursorline

" always show sign columns
set signcolumn=yes

" directory view
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25

augroup TerminalStuff
   au!
  autocmd TermOpen * setlocal
    \ signcolumn=no
    \ nonumber
    \ norelativenumber 
    \ | startinsert
augroup END

