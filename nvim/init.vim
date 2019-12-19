set encoding=utf-8
scriptencoding utf-8
" TODO: alt + left/right move by word left/right
" TODO: highlight usages of object under cursor
" TODO: split vimrc into multiple files
" TODO: disable line numbers in terminal
" TODO: autodetect (or set?) project root for autocompletion and go to
" definition
" TODO: show indent guides and coupled operators (like for, else, end)
" https://github.com/thaerkh/vim-indentguides
" https://github.com/nathanaelkane/vim-indent-guides
"
" TODO: select first item when use autocompletion to use only Enter
" TODO: bind Ctrl+[ to go back from where went to definition
" TODO: show time in statusline
" TODO: do not move cursor when scrolling file
" TODO: do not use autocompletion when writing comments
" TODO: spellcheck
" TODO: ajust copy mode settings and mappings
" TODO: custom indent guides for different languages
" TODO: forward mouse scroll to terminal buffer (man, less)
runtime plugins.vim

" ======= General ======= "
" do not unload buffer when it is abandoned
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
set scrolloff=7

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
" tabs
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
set completeopt=menu,menuone,preview,noselect,noinsert

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

"if has('win32')
"  "function Comment
"  imap <C-/> <esc>\c<space><CR>i
"  vmap <C-/> \c<space>gv
"else
"  imap <C-_> <esc>\c<space><CR>i
"  vmap <C-_> \c<space>gv
"endif
"
"

augroup TerminalStuff
   au!
  autocmd TermOpen * setlocal nonumber norelativenumber | startinsert
augroup END

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
