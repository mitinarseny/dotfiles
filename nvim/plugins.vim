" check if vim-plug is installed and install it if necessary
let plugpath = expand('<sfile>:p:h') . '/autoload/plug.vim'
if !filereadable(plugpath)
  if executable('curl')
    let plugURL = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    call system('curl -fLo ' . shellescape(plugpath) . ' --create-dirs ' . plugURL)
    if v:shell_error
      echom 'Error while downloading vim-plug. Please, install it manually.\n'
      exit
    endif
  else
    echom 'vim-plug is not installed. Please, install it manually or install curl.\n'
    exit
  endif
endif

call plug#begin('~/.config/nvim/plugged')

" ===== General ===== "
" Follow symlinks
Plug 'moll/vim-bbye' " vim-symlink optional dependency
Plug 'aymericbeaumet/vim-symlink'

" ===== Editing ===== "
" Language Server Protocol
Plug 'dense-analysis/ale'

" Intellij Sense engine
Plug 'neoclide/coc.nvim', { 'branch': 'release' }

" Fuzzy search
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" Comments
Plug 'tomtom/tcomment_vim'

" ===== UI ===== "
" Color scheme
Plug 'arcticicestudio/nord-vim'

" Enchanced statusline
Plug 'itchyny/lightline.vim'

" Lightline + ALE
Plug 'maximbaz/lightline-ale'

" File explorer
Plug 'scrooloose/nerdtree'

" Start screen
Plug 'mhinz/vim-startify'
" ===== VCS ===== "
" Git intergation
Plug 'tpope/vim-fugitive'

" Git diff gutter
Plug 'airblade/vim-gitgutter'

" Git integration for NERDTree
Plug 'Xuyuanp/nerdtree-git-plugin'

" ===== Languages ===== "
" === Golang === "
" Full-featured Golang IDE
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

call plug#end()
