scriptencoding utf-8
" check if vim-plug is installed and install it if necessary
let autoload_plug_path = stdpath('data') . '/site/autoload/plug.vim'
if !filereadable(autoload_plug_path)
  if !executable('curl')
    echo 'vim-plug is not installed. Please, install it manually or install curl and check if it is in $PATH'
    exit
  endif
  silent execute '!curl --fail --location --output ' . shellescape(autoload_plug_path) . ' --create-dirs "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC 
endif
unlet autoload_plug_path

" ======= Load Plugins ======= "
call plug#begin(stdpath('data') . '/plugged')

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

" Auto-pairs
Plug 'jiangmiao/auto-pairs'

" Tags
Plug 'ludovicchabant/vim-gutentags'

" ===== UI ===== "
" Color scheme
Plug 'arcticicestudio/nord-vim'

" Enchanced statusline
Plug 'itchyny/lightline.vim'

" Lightline + ALE
Plug 'maximbaz/lightline-ale'

" Show indent guides
Plug 'Yggdroot/indentLine'

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

" === Rust === "
Plug 'rust-lang/rust.vim'

call plug#end()

" ======= Plugins Settings ======= "
" ===== arcticicestudio/nord-vim =====
let g:nord_bold_vertical_split_line = 1
let g:nord_uniform_diff_background = 1
colorscheme nord

" ===== itchyny/lightline.vim =====
" diable built-in statusline
set noshowmode

let g:lightline = {
  \   'colorscheme': 'nord',
  \   'active': {
  \     'left': [
  \       ['mode', 'paste'],
  \       ['gitbranch', 'filename'],
  \      ],
  \      'right': [
  \        ['readonly'],
  \        ['fileformat', 'fileencoding', 'lineinfo'],
  \        ['linter_checking', 'linter_errors', 'linter_wanrings', 'linter_ok'],
  \      ],
  \   },
  \   'inactive': {
  \     'left': [
  \       ['filename'],
  \     ],
  \     'right': [
  \       ['lineinfo'],
  \     ],
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
  \     'linter_checking': 'middle',
  \     'linter_wanrings': 'warning',
  \     'linter_errors': 'error',
  \     'linter_ok': 'middle',
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

" ===== junegunn/fzf =====
let g:fzf_colors = { 
  \ 'fg':      ['fg', 'Normal',],
  \ 'bg':      ['bg', 'Normal',],
  \ 'hl':      ['fg', 'SpellCap',],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal',],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn',],
  \ 'hl+':     ['fg', 'SpellCap',],
  \ 'info':    ['fg', 'Comment',],
  \ 'border':  ['fg', 'Ignore',],
  \ 'prompt':  ['fg', 'SpecialComment',],
  \ 'pointer': ['fg', 'Exception',],
  \ 'marker':  ['fg', 'SpellBad',],
  \ 'spinner': ['fg', 'Comment',],
  \ 'header':  ['fg', 'Comment',],
  \ }

let g:fzf_layout = {
  \ 'down': '~30%',
  \ }

noremap <silent> <C-f> :FZF<CR>


" ===neoclide/coc.nvim =====
" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()


"Using floating windows of Neovim to start fzf
" if has('nvim')
"   let $FZF_DEFAULT_OPTS .= ' --border --margin=0,2'
"
"   function! FloatingFZF()
"     let width = float2nr(&columns * 0.9)
"     let height = float2nr(&lines * 0.6)
"     let opts = { 'relative': 'editor',
"                \ 'row': (&lines - height) / 2,
"                \ 'col': (&columns - width) / 2,
"                \ 'width': width,
"                \ 'height': height }
"
"     let win = nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
"     call setwinvar(win, '&winhighlight', 'NormalFloat:Normal')
"   endfunction
"
"   let g:fzf_layout = { 'window': 'call FloatingFZF()' }
" endif

if has('nvim')
  augroup fzf
    au!
    autocmd! FileType fzf
    autocmd  FileType fzf set laststatus=0 noshowmode noruler notitle
      \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler title
  augroup END
endif


" ===== dense-analysis/ale =====
let g:ale_lint_on_text_changed='always'

" ===== mhinz/vim-startify =====
let g:startify_custom_header = []
let g:startify_use_env = 1

" ===== Yggdroot/indentLine =====
let g:indentLine_color_term = 0
let g:indentLine_bgcolor_term = 'NONE'
let g:indentLine_color_gui = '#3b4252'
let g:indentLine_bgcolor_gui = 'NONE'
let g:indentLine_concealcursor = 0

" ===== fatih/vim-go =====
let g:go_highlight_array_whitespace_error    = 1
let g:go_highlight_chan_whitespace_error     = 1
let g:go_highlight_extra_types               = 1
let g:go_highlight_trailing_whitespace_error = 1
let g:go_highlight_operators                 = 1
let g:go_highlight_functions                 = 1
let g:go_highlight_function_parameters       = 1
let g:go_highlight_function_calls            = 1
let g:go_highlight_fields                    = 1
let g:go_highlight_build_constraints         = 1
let g:go_highlight_generate_tags             = 1
let g:go_highlight_variable_declarations     = 1
let g:go_highlight_variable_assignments      = 1 
