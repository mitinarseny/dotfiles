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

  Plug 'airblade/vim-rooter'
    let g:rooter_targets       = '*'
    let g:rooter_silent_chdir  = 1
    let g:rooter_patterns      = ['.git', '.git/']
    let g:rooter_resolve_links = 1

  Plug 'prabirshrestha/async.vim'
  Plug 'prabirshrestha/vim-lsp'
    let g:lsp_diagnostics_enabled          = v:true
    let g:lsp_diagnostics_echo_cursor      = v:true
    let g:lsp_diagnostics_echo_delay       = 200
    let g:lsp_signs_enabled                = v:true
    let g:lsp_signs_error                  = { 'text': '>>' }
    let g:lsp_signs_warning                = { 'text': '--' }
    let g:lsp_signs_hint                   = { 'text': '..' }
    let g:lsp_virtual_text_enabled         = v:false
    let g:lsp_highlight_references_enabled = v:true
    let g:lsp_signature_help_enabled       = v:true
    let g:lsp_async_completion             = v:true

    " Close preview window with <esc>
    autocmd User lsp_float_opened nmap <buffer> <silent> <Esc>
      \ <Plug>(lsp-preview-close)
    autocmd User lsp_float_closed call lsp#ui#vim#references#highlight(v:false)
      \ | nunmap <buffer> <Esc>

    if executable('gopls')
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

  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
    let g:asyncomplete_auto_popup       = v:true
    let g:asyncomplete_auto_completeopt = v:false

    set completeopt=menuone,noinsert,noselect

    function! s:on_lsp_buffer_enabled() abort
      setlocal omnifunc=lsp#complete
      setlocal signcolumn=yes

      highlight lspReference cterm=underline

      nnoremap <buffer> <silent> <C-]>                    <Cmd>LspDefinition<CR>
      inoremap <buffer> <silent> <C-]>                    <Cmd>LspDefinition<CR>
      nnoremap <buffer> <silent> <C-LeftMouse> <LeftMouse><Cmd>LspDefinition<CR>
      inoremap <buffer> <silent> <C-LeftMouse> <LeftMouse><Cmd>LspDefinition<CR>

      nnoremap <buffer> <Leader>lu <Cmd>LspReferences<CR>
      nnoremap <buffer> <Leader>lr <Cmd>LspRename<CR>
      nnoremap <buffer> <Leader>lh <Cmd>LspHover<CR>
    endfunction

    augroup lsp_install
      autocmd!
      autocmd User lsp_buffer_enabled call <SID>on_lsp_buffer_enabled()
      autocmd User lsp_complete_done  call asyncomplete#close_popup()
    augroup END

  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
    let g:fzf_buffers_jump    = v:true
    let g:fzf_statusline      = v:false
    let g:fzf_nvim_statusline = v:false

    " let g:fzf_action = {
    "   \ 'ctrl-t': 'tab split',
    "   \ 'ctrl-_': 'split',
    "   \ 'ctrl-\': 'vsplit',
    "   \ }
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

    let g:fzf_history_dir = '~/.local/share/fzf-history'

    command! -bang -nargs=? -complete=dir Files
      \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)

    function! s:fzf_ripgrep(query, fullscreen)
      let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
      let initial_command = printf(command_fmt, shellescape(a:query))
      let reload_command = printf(command_fmt, '{q}')
      let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
      call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
    endfunction
    command! -nargs=* -bang RG call <SID>fzf_ripgrep(<q-args>, <bang>0)

    nnoremap <Leader>ff <Cmd>Files<CR>
    nnoremap <Leader>fr <Cmd>RG<CR>

    autocmd! FileType fzf setlocal laststatus=0 noshowmode noruler
      \ | autocmd BufWinLeave <buffer> setlocal laststatus=2 ruler
  
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
      \        ['lsp_errors', 'lsp_warnings', 'lsp_ok'],
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
      \     'readonly':     'LightlineReadonly',
      \     'lsp_warnings': 'LightlineLSPWarnings',
      \     'lsp_errors':   'LightlineLSPErrors',
      \     'lsp_ok':       'LightlineLSPOk',
      \   },
      \   'component_type': {
      \     'readonly':     'error',
      \     'lsp_warnings': 'warning',
      \     'lsp_errors':   'error',
      \     'lsp_ok':       'middle',
      \   },
      \   'component_function': {
      \     'gitbranch':  'fugitive#head',
      \     'filename':   'LightlineFilename',
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

    function! LightlineFilename()
      let filename = expand('%:t')
      return (filename ==# '' ? '[No Name]' : filename) . (&modified ? ' +' : '')
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

    function! LightlineLSPWarnings() abort
      let l:counts = lsp#ui#vim#diagnostics#get_buffer_diagnostics_counts()
      return l:counts.warning == 0 ? '' : printf('W:%d', l:counts.warning)
    endfunction

    function! LightlineLSPErrors() abort
      let l:counts = lsp#ui#vim#diagnostics#get_buffer_diagnostics_counts()
      return l:counts.error == 0 ? '' : printf('E:%d', l:counts.error)
    endfunction

    function! LightlineLSPOk() abort
      let l:counts =  lsp#ui#vim#diagnostics#get_buffer_diagnostics_counts()
      let l:total = l:counts.error + l:counts.warning
      return l:total == 0 ? 'OK' : ''
    endfunction

    augroup LightLineOnLSP
      autocmd!
      autocmd User lsp_diagnostics_updated call lightline#update()
    augroup END

  Plug 'Yggdroot/indentLine'
    let g:indentLine_color_term    = 0
    let g:indentLine_bgcolor_term  = 'NONE'
    let g:indentLine_color_gui     = '#3b4252'
    let g:indentLine_bgcolor_gui   = 'NONE'
    let g:indentLine_concealcursor = 0

    augroup IndentLineOnFZF
      autocmd!
      autocmd FileType fzf IndentLinesDisable
    augroup END


  Plug 'mhinz/vim-startify'
    let g:startify_custom_header = []
    let g:startify_use_env       = v:true

  Plug 'tpope/vim-fugitive'

  Plug 'airblade/vim-gitgutter'
    let g:gitgutter_sign_priority      = 0
    let g:gitgutter_sign_allow_clobber = v:false

  Plug 'sheerun/vim-polyglot'

  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries'}
    let g:go_def_mapping_enabled                 = v:false
    let g:go_code_completion_enabled             = v:false
    let g:go_imports_autosave                    = v:false
    let g:go_fmt_autosave                        = v:false
    let g:go_mod_fmt_autosave                    = v:false
    let go_gopls_enabled                         = v:false
    let g:go_echo_command_info                   = v:false
    let g:go_echo_go_info                        = v:false
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

  Plug 'rust-lang/rust.vim', { 'for': 'rust' }
  Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
  Plug 'tmux-plugins/vim-tmux'
    let g:vim_markdown_folding_disabled    = v:true
    let g:vim_markdown_conceal             = v:false
    let g:vim_markdown_conceal_code_blocks = v:false

call plug#end()

colorscheme nord

