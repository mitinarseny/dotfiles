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
  Plug 'tpope/vim-vinegar'
  Plug 'moll/vim-bbye' " vim-symlink optional dependency
  Plug 'aymericbeaumet/vim-symlink'

  Plug 'airblade/vim-rooter'
    let g:rooter_targets       = '*'
    let g:rooter_silent_chdir  = v:true
    let g:rooter_patterns      = ['.git', '.git/']
    let g:rooter_resolve_links = v:true

  Plug 'prabirshrestha/async.vim'
  Plug 'prabirshrestha/vim-lsp'
    let g:lsp_diagnostics_enabled                   = v:true
    let g:lsp_diagnostics_echo_cursor               = v:true
    let g:lsp_diagnostics_echo_delay                = 200
    let g:lsp_diagnostics_signs_enabled             = v:true
    let g:lsp_diagnostics_signs_insert_mode_enabled = v:true
    let g:lsp_diagnostics_signs_error               = { 'text': '>>' }
    let g:lsp_diagnostics_signs_warning             = { 'text': '--' }
    let g:lsp_diagnostics_signs_hint                = { 'text': '..' }
    let g:lsp_diagnostics_virtual_text_enabled      = v:false
    let g:lsp_signature_help_enabled                = v:true
    let g:lsp_semantic_enabled                      = v:true
    let g:lsp_work_done_progress_enabled            = v:true
    let g:lsp_show_message_request_enabled          = v:true

    augroup lsp_setup | autocmd!
      function! s:on_lsp_buffer_enabled() abort
        setlocal signcolumn=yes

        highlight lspReference cterm=underline

        nmap <buffer> <silent> <C-]>                         <Plug>(lsp-definition)
        imap <buffer> <silent> <C-]>                    <C-O><Plug>(lsp-definition)
        nmap <buffer> <silent> <C-LeftMouse> <LeftMouse>     <Plug>(lsp-definition)
        imap <buffer> <silent> <C-LeftMouse> <LeftMouse><C-o><Plug>(lsp-definition)

        nmap <buffer> <Leader>lr <Plug>(lsp-rename)
        nmap <buffer> <Leader>lu <Plug>(lsp-references)
        nmap <buffer> <Leader>li <Plug>(lsp-implementation)
        nmap <buffer> <Leader>lh <Plug>(lsp-hover)
      endfunction
      autocmd User lsp_buffer_enabled call <SID>on_lsp_buffer_enabled()
    augroup END

    augroup Lsp | autocmd!
      if executable('clangd')
        autocmd User lsp_setup call lsp#register_server({
          \ 'name': 'Cxx',
          \ 'cmd': {server_info -> ['clangd', '-background-index']},
          \ 'allowlist': ['c', 'cpp', 'objc', 'objcpp'],
          \ })
      endif

      if executable('gopls')
        autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'Golang',
        \ 'cmd': {server_info -> ['gopls']},
        \ 'allowlist': ['go'],
        \ })
      endif

      if executable('pyls')
        autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'Python',
        \ 'cmd': {server_info -> ['pyls']},
        \ 'allowlist': ['python'],
        \ })
      endif

      if executable('yaml-language-server')
        autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'YAML',
        \ 'cmd': {server_info -> ['yaml-language-server', '--stdio']},
        \ 'allowlist': ['yaml', 'yaml.ansible'],
        \ 'workspace_config': {
        \   'yaml': {
        \     'validate': v:true,
        \     'hover': v:true,
        \     'completion': v:true,
        \     'customTags': [],
        \     'schemas': {},
        \     'schemaStore': {'enable': v:true},
        \   },
        \ }})
      endif

      if executable('vim-language-server')
        autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'Vim',
        \ 'cmd': {server_info -> ['vim-language-server', '--stdio']},
        \ 'allowlist': ['vim'],
        \ 'initialization_options': {
        \   'vimruntime': $VIMRUNTIME,
        \   'runtimepath': &rtp,
        \ }})
      endif

      if executable('bash-language-server')
        autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'Bash',
        \ 'cmd': {server_info -> ['bash-language-server', 'start']},
        \ 'allowlist': ['sh'],
        \ })
      endif

      if executable('docker-langserver')
        autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'Docker',
        \ 'cmd': {server_info -> ['docker-langserver', '--stdio']},
        \ 'allowlist': ['dockerfile'],
        \ })
      endif
    augroup END

  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
    let g:asyncomplete_auto_popup       = v:true
    let g:asyncomplete_auto_completeopt = v:false

    set completeopt=menuone,noinsert,noselect

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

    nnoremap <silent> <Leader>f <Cmd>Files<CR>
    nnoremap <silent> <Leader>r <Cmd>RG<CR>
    nnoremap <silent> <Leader>h <Cmd>BLines<CR>
    nnoremap <silent> <Leader>b <Cmd>Buffers<CR>

    augroup fzf_setup | autocmd!
      function! s:on_fzf()
        let [b:laststatus, b:ruler, b:showmode] = [&laststatus, &ruler, &showmode]
        autocmd BufEnter <buffer> startinsert
        autocmd BufWinLeave <buffer> call setwinvar(winnr(), '&laststatus', b:laststatus)
          \ | call setwinvar(winnr(), '&ruler', b:ruler)
          \ | call setwinvar(winnr(), '&showmode', b:showmode)
        setlocal laststatus=0 noshowmode noruler
      endfunction
      autocmd! FileType fzf call <SID>on_fzf()
    augroup END
  
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
      \     'gitbranch':    'fugitive#head',
      \     'filename':     'LightlineFilename',
      \     'fileformat':   'LightlineFileformat',
      \     'filetype':     'LightlineFiletype',
      \     'fileencoding': 'LightlineFileencoding'
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
      return &readonly && &buftype != 'help' && &filetype != 'netrw' ? 'RO' : ''
    endfunction

    function! LightlineFileformat()
      return winwidth(0) > 70 ? &fileformat : ''
    endfunction

    function! LightlineFiletype()
      return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
    endfunction

    function! LightlineFileencoding()
      return winwidth(0) > 70 ? &fileencoding : ''
    endfunction

    function! LightlineLSPWarnings() abort
      let l:counts = lsp#get_buffer_diagnostics_counts()
      return l:counts.warning == 0 ? '' : printf('W:%d', l:counts.warning)
    endfunction

    function! LightlineLSPErrors() abort
      let l:counts = lsp#get_buffer_diagnostics_counts()
      return l:counts.error == 0 ? '' : printf('E:%d', l:counts.error)
    endfunction

    function! LightlineLSPOk() abort
      let l:counts =  lsp#get_buffer_diagnostics_counts()
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
    let g:go_highlight_space_tab_error           = v:true
    let g:go_highlight_trailing_whitespace_error = v:true
    let g:go_highlight_operators                 = v:true
    let g:go_highlight_functions                 = v:true
    let g:go_highlight_function_parameters       = v:true
    let g:go_highlight_function_calls            = v:true
    let g:go_highlight_types                     = v:true
    let g:go_highlight_fields                    = v:true
    let g:go_highlight_build_constraints         = v:true
    let g:go_highlight_generate_tags             = v:true
    let g:go_highlight_string_spellcheck         = v:true
    let g:go_highlight_format_strings            = v:true
    let g:go_highlight_variable_declarations     = v:true
    let g:go_highlight_variable_assignments      = v:true
    let g:go_highlight_diagnostic_errors         = v:true
    let g:go_highlight_diagnostic_warnings       = v:true

  Plug 'rust-lang/rust.vim', { 'for': 'rust' }
  Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
  Plug 'tmux-plugins/vim-tmux'
    let g:vim_markdown_folding_disabled    = v:true
    let g:vim_markdown_conceal             = v:false
    let g:vim_markdown_conceal_code_blocks = v:false

  Plug 'cdelledonne/vim-cmake'

call plug#end()

colorscheme nord

