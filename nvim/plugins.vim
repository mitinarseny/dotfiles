scriptencoding utf-8

" check if vim-plug is installed and install it if necessary
let s:autoload_plug_path = stdpath('data') . '/site/autoload/plug.vim'
if !filereadable(s:autoload_plug_path)
  if !executable('curl')
    echo 'vim-plug is not installed. Please, install it manually or install curl and check if it is in $PATH'
    exit
  endif
  silent execute '!curl --fail --location --output ' . shellescape(s:autoload_plug_path) . ' --create-dirs "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC 
endif

call plug#begin(stdpath('data') . '/plugged')
  Plug 'moll/vim-bbye' " vim-symlink optional dependency
  Plug 'aymericbeaumet/vim-symlink'

  Plug 'dense-analysis/ale'
    let g:ale_completion_enabled   = 0
    let g:ale_lint_on_text_changed = 'always'

  Plug 'prabirshrestha/async.vim'
  Plug 'prabirshrestha/vim-lsp'    
    let g:lsp_diagnostics_enabled          = v:false
    let g:lsp_highlight_references_enabled = v:true
    let g:lsp_signature_help_enabled       = v:true
    let g:lsp_async_completion             = v:true
 
  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
    let g:asyncomplete_auto_popup       = v:true
    let g:asyncomplete_auto_completeopt = v:false

    set completeopt=menuone,noinsert,noselect

    function! s:on_lsp_buffer_enabled() abort
      setlocal omnifunc=lsp#complete
      setlocal signcolumn=yes

      highlight lspReference term=underline ctermbg=8

      noremap  <buffer> <silent> <C-]>                    <Cmd>LspDefinition<CR>
      inoremap <buffer> <silent> <C-]>                    <Cmd>LspDefinition<CR>
      noremap  <buffer> <silent> <C-LeftMouse> <LeftMouse><Cmd>LspDefinition<CR>
      inoremap <buffer> <silent> <C-LeftMouse> <LeftMouse><Cmd>LspDefinition<CR>
    endfunction

    augroup lsp_install
      autocmd!
      autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
      autocmd User lsp_complete_done  call asyncomplete#close_popup()
    augroup END

  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
    let g:fzf_colors = { 
      \ 'fg':      ['fg', 'Normal'],
      \ 'bg':      ['bg', 'Normal'],
      \ 'hl':      ['fg', 'SpellCap'],
      \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
      \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
      \ 'hl+':     ['fg', 'SpellCap'],
      \ 'info':    ['fg', 'Comment'],
      \ 'border':  ['fg', 'Ignore'],
      \ 'prompt':  ['fg', 'SpecialComment'],
      \ 'pointer': ['fg', 'Exception'],
      \ 'marker':  ['fg', 'SpellBad'],
      \ 'spinner': ['fg', 'Comment'],
      \ 'header':  ['fg', 'Comment'],
      \ }

    let g:fzf_layout = {
      \ 'down': '~30%',
      \ }

    noremap <silent> <C-f> :FZF<CR>

    " Using floating windows of Neovim to start fzf
    if has('nvim')
      let $FZF_DEFAULT_OPTS .= ' --border --margin=0,2'

    function! FloatingFZF()
        let width = float2nr(&columns * 0.9)
        let height = float2nr(&lines * 0.6)
        let opts = { 'relative': 'editor',    
          \ 'row': (&lines - height) / 2,
          \ 'col': (&columns - width) / 2,
          \ 'width': width,
          \ 'height': height,
          \ }
        let win = nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
        call setwinvar(win, '&winhighlight', 'NormalFloat:Normal')
      endfunction

      let g:fzf_layout = { 'window': 'call FloatingFZF()' }

      augroup fzf
        autocmd!
        autocmd  FileType fzf set laststatus=0 noshowmode noruler notitle
          \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler title
      augroup END
    endif

  Plug 'tomtom/tcomment_vim'
    autocmd FileType * setlocal formatoptions-=ro

  Plug 'junegunn/vim-easy-align'

  Plug 'jiangmiao/auto-pairs'

  Plug 'ludovicchabant/vim-gutentags'
    let g:gutentags_ctags_tagfile = ".tags"

  Plug 'majutsushi/tagbar'

  Plug 'arcticicestudio/nord-vim'
    let g:nord_bold_vertical_split_line = v:true
    let g:nord_uniform_diff_background  = v:true

  Plug 'chrisbra/Colorizer'

  Plug 'itchyny/lightline.vim'
  Plug 'maximbaz/lightline-ale'
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
      \     'lineinfo': '%3l:%-2v',
      \   },
      \   'component_expand': {
      \     'readonly':        'LightlineReadonly',
      \     'linter_checking': 'lightline#ale#checking',
      \     'linter_wanrings': 'lightline#ale#warnings',
      \     'linter_errors':   'lightline#ale#errors',
      \     'linter_ok':       'lightline#ale#ok',
      \   },
      \   'component_type': {
      \     'readonly':        'error',
      \     'linter_checking': 'middle',
      \     'linter_wanrings': 'warning',
      \     'linter_errors':   'error',
      \     'linter_ok':       'middle',
      \   },
      \   'component_function': {
      \     'gitbranch':  'fugitive#head',
      \     'filename':   'LightlineFileName',
      \     'fileformat': 'LightlineFileformat',
      \     'filetype':   'LightlineFiletype',
      \   },
      \   'separator':    { 'left': '',  'right': ''  },
      \   'subseparator': { 'left': '|', 'right': '|' },
      \   'mode_map': {
      \     'n':      'N',
      \     'i':      'I',
      \     'R':      'R',
      \     'v':      'V',
      \     'V':      'VL',
      \     "\<C-v>": 'VB',
      \     'c':      'C',
      \     's':      'S',
      \     'S':      'SL',
      \     "\<C-s>": 'SB',
      \     't':      'T',
      \   },
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

  Plug 'Yggdroot/indentLine'
    let g:indentLine_color_term    = 0
    let g:indentLine_bgcolor_term  = 'NONE'
    let g:indentLine_color_gui     = '#3b4252'
    let g:indentLine_bgcolor_gui   = 'NONE'
    let g:indentLine_concealcursor = 0

  Plug 'mhinz/vim-startify'
    let g:startify_custom_header = []
    let g:startify_use_env       = v:true

  Plug 'tpope/vim-fugitive'

  Plug 'airblade/vim-gitgutter'

  Plug 'sheerun/vim-polyglot'

"  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries'}
    let g:go_highlight_array_whitespace_error    = v:true
    let g:go_highlight_chan_whitespace_error     = v:true
    let g:go_highlight_extra_types               = v:true
    let g:go_highlight_trailing_whitespace_error = v:true
    let g:go_highlight_operators                 = v:true
    let g:go_highlight_functions                 = v:true
    let g:go_highlight_function_parameters       = v:true
    let g:go_highlight_function_calls            = v:true
    let g:go_highlight_fields                    = v:true
    let g:go_highlight_build_constraints         = v:true
    let g:go_highlight_generate_tags             = v:true
    let g:go_highlight_variable_declarations     = v:true
    let g:go_highlight_variable_assignments      = v:true
    let g:go_highlight_string_spellcheck         = v:true
    let g:go_highlight_diagnostic_errors         = v:true
    let g:go_highlight_diagnostic_warnings       = v:true
    let g:go_fmt_command                         = 'goimports'
    let g:go_def_mode                            = 'gopls'
    let g:go_info_mode                           = 'gopls'
    
  Plug 'rust-lang/rust.vim', { 'for': 'rust' }
  Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
  Plug 'tmux-plugins/vim-tmux'
    let g:vim_markdown_folding_disabled    = v:true
    let g:vim_markdown_conceal             = v:false
    let g:vim_markdown_conceal_code_blocks = v:false

call plug#end()

colorscheme nord

