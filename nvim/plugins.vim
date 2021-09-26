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

  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/nvim-compe'

  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
    nnoremap <Leader>ff <Cmd>lua require('telescope.builtin').find_files()<CR>
    nnoremap <Leader>fg <Cmd>lua require('telescope.builtin').live_grep()<CR>
    nnoremap <Leader>fc <Cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>
    nnoremap <Leader>fb <Cmd>lua require('telescope.builtin').buffers()<CR>
    nnoremap <Leader>ft <Cmd>lua require('telescope.builtin').file_browser()<CR>

    nnoremap <Leader>gc <Cmd>lua require('telescope.builtin').git_commits()<CR>
    nnoremap <Leader>gb <Cmd>lua require('telescope.builtin').git_branches()<CR>

    nnoremap <Leader>va <Cmd>lua require('telescope.builtin').autocommands()<CR>
    nnoremap <Leader>vh <Cmd>lua require('telescope.builtin').highlights()<CR>
    nnoremap <Leader>vm <Cmd>lua require('telescope.builtin').man_pages()<CR>

    autocmd User TelescopePreviewerLoaded setlocal wrap

  " Plug 'prabirshrestha/async.vim'
  " Plug 'prabirshrestha/vim-lsp'
  "   let g:lsp_diagnostics_enabled                   = v:true
  "   let g:lsp_diagnostics_echo_cursor               = v:true
  "   let g:lsp_diagnostics_echo_delay                = 200
  "   let g:lsp_diagnostics_signs_enabled             = v:true
  "   let g:lsp_diagnostics_signs_insert_mode_enabled = v:true
  "   let g:lsp_diagnostics_signs_error               = { 'text': '>>' }
  "   let g:lsp_diagnostics_signs_warning             = { 'text': '--' }
  "   let g:lsp_diagnostics_signs_hint                = { 'text': '..' }
  "   let g:lsp_diagnostics_virtual_text_enabled      = v:false
  "   let g:lsp_fold_enabled                          = v:false
  "   let g:lsp_signature_help_enabled                = v:true
  "   let g:lsp_semantic_enabled                      = v:true
  "   let g:lsp_work_done_progress_enabled            = v:true
  "   let g:lsp_show_message_request_enabled          = v:true
  "
  "   augroup lsp_setup | autocmd!
  "     function! s:on_lsp_buffer_enabled() abort
  "       setlocal signcolumn=yes
  "
  "       highlight lspReference cterm=underline
  "
  "       nmap <buffer> <silent> <C-]>                         <Plug>(lsp-definition)
  "       imap <buffer> <silent> <C-]>                    <C-O><Plug>(lsp-definition)
  "       nmap <buffer> <silent> <C-LeftMouse> <LeftMouse>     <Plug>(lsp-definition)
  "       imap <buffer> <silent> <C-LeftMouse> <LeftMouse><C-o><Plug>(lsp-definition)
  "
  "       nmap <buffer> <Leader>lr       <Plug>(lsp-rename)
  "       nmap <buffer> <Leader>lu       <Plug>(lsp-references)
  "       nmap <buffer> <Leader>li       <Plug>(lsp-implementation)
  "       nmap <buffer> <Leader>lh       <Plug>(lsp-hover)
  "       map  <buffer> <Leader>lf       <Plug>(lsp-document-format)
  "       nmap <buffer> <Leader>l<Right> <Plug>(lsp-next-reference)
  "       nmap <buffer> <Leader>l<Left>  <Plug>(lsp-previous-reference)
  "       nmap <buffer> <Leader>le       <Plug>(lsp-next-error)
  "       nmap <buffer> <Leader>la       <Plug>(lsp-code-action)
  "     endfunction
  "     autocmd User lsp_buffer_enabled call <SID>on_lsp_buffer_enabled()
  "   augroup END
  "
  "   augroup Lsp | autocmd!
  "     if executable('clangd')
  "       autocmd User lsp_setup call lsp#register_server({
  "         \ 'name': 'Cxx',
  "         \ 'cmd': {server_info -> ['clangd', '-background-index']},
  "         \ 'allowlist': ['c', 'cpp', 'objc', 'objcpp'],
  "         \ })
  "     endif
  "
  "     if executable('gopls')
  "       autocmd User lsp_setup call lsp#register_server({
  "       \ 'name': 'Golang',
  "       \ 'cmd': {server_info -> ['gopls']},
  "       \ 'allowlist': ['go'],
  "       \ })
  "     endif
  "
  "     if executable('pyls')
  "       autocmd User lsp_setup call lsp#register_server({
  "       \ 'name': 'Python',
  "       \ 'cmd': {server_info -> ['pyls']},
  "       \ 'allowlist': ['python'],
  "       \ })
  "     endif
  "
  "     if executable('yaml-language-server')
  "       autocmd User lsp_setup call lsp#register_server({
  "       \ 'name': 'YAML',
  "       \ 'cmd': {server_info -> ['yaml-language-server', '--stdio']},
  "       \ 'allowlist': ['yaml', 'yaml.ansible'],
  "       \ 'workspace_config': {
  "       \   'yaml': {
  "       \     'validate': v:true,
  "       \     'hover': v:true,
  "       \     'completion': v:true,
  "       \     'customTags': [],
  "       \     'schemas': {},
  "       \     'schemaStore': {'enable': v:true},
  "       \   },
  "       \ }})
  "     endif
  "
  "     if executable('vim-language-server')
  "       autocmd User lsp_setup call lsp#register_server({
  "       \ 'name': 'Vim',
  "       \ 'cmd': {server_info -> ['vim-language-server', '--stdio']},
  "       \ 'allowlist': ['vim'],
  "       \ 'initialization_options': {
  "       \   'vimruntime': $VIMRUNTIME,
  "       \   'runtimepath': &rtp,
  "       \ }})
  "     endif
  "
  "     if executable('bash-language-server')
  "       autocmd User lsp_setup call lsp#register_server({
  "       \ 'name': 'Bash',
  "       \ 'cmd': {server_info -> ['bash-language-server', 'start']},
  "       \ 'allowlist': ['sh'],
  "       \ })
  "     endif
  "
  "     if executable('docker-langserver')
  "       autocmd User lsp_setup call lsp#register_server({
  "       \ 'name': 'Docker',
  "       \ 'cmd': {server_info -> ['docker-langserver', '--stdio']},
  "       \ 'allowlist': ['dockerfile'],
  "       \ })
  "     endif
  "   augroup END
  "
  " Plug 'prabirshrestha/asyncomplete.vim'
  " Plug 'prabirshrestha/asyncomplete-lsp.vim'
  "   let g:asyncomplete_auto_popup       = v:true
  "   let g:asyncomplete_auto_completeopt = v:false
  "
  "   set completeopt=menuone,noinsert,noselect
  "
  "   inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
  "   inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
  "   inoremap <expr> <CR>    pumvisible() ? asyncomplete#close_popup() : "\<CR>"

  " Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': { -> fzf#install() } }
  " Plug 'junegunn/fzf.vim'
  "   let g:fzf_buffers_jump    = v:true
  "   let g:fzf_statusline      = v:false
  "   let g:fzf_nvim_statusline = v:false
  "
  "   " let g:fzf_action = {
  "   "   \ 'ctrl-t': 'tab split',
  "   "   \ 'ctrl-_': 'split',
  "   "   \ 'ctrl-\': 'vsplit',
  "   "   \ }
  "   let g:fzf_colors = {
  "     \ 'fg':      ['fg', 'Normal'],
  "     \ 'bg':      ['bg', 'Normal'],
  "     \ 'hl':      ['fg', 'SpellCap'],
  "     \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  "     \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  "     \ 'hl+':     ['fg', 'SpellCap'],
  "     \ 'info':    ['fg', 'Comment'],
  "     \ 'border':  ['fg', 'Ignore'],
  "     \ 'prompt':  ['fg', 'SpecialComment'],
  "     \ 'pointer': ['fg', 'Exception'],
  "     \ 'marker':  ['fg', 'SpellBad'],
  "     \ 'spinner': ['fg', 'Comment'],
  "     \ 'header':  ['fg', 'Comment'],
  "     \ }
  "
  "   let g:fzf_layout = {
  "     \ 'down': '~30%',
  "     \ }
  "
  "   let g:fzf_history_dir = '~/.local/share/fzf-history'
  "
  "   command! -bang -nargs=? -complete=dir Files
  "     \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--ansi', '--layout=reverse', '--info=inline']}), <bang>0)
  "
  "   function! s:fzf_ripgrep(query, fullscreen)
  "     let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
  "     let initial_command = printf(command_fmt, shellescape(a:query))
  "     let reload_command = printf(command_fmt, '{q}')
  "     let spec = {'options': ['--ansi', '--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  "     call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
  "   endfunction
  "   command! -nargs=* -bang RG call <SID>fzf_ripgrep(<q-args>, <bang>0)
  "
  "   nnoremap <silent> <Leader>f <Cmd>Files<CR>
  "   nnoremap <silent> <Leader>r <Cmd>RG<CR>
  "   nnoremap <silent> <Leader>h <Cmd>BLines<CR>
  "   nnoremap <silent> <Leader>b <Cmd>Buffers<CR>
  "
  "   augroup fzf_setup | autocmd!
  "     function! s:on_fzf()
  "       let [b:laststatus, b:ruler, b:showmode] = [&laststatus, &ruler, &showmode]
  "       autocmd BufEnter <buffer> startinsert
  "       autocmd BufWinLeave <buffer> call setwinvar(winnr(), '&laststatus', b:laststatus)
  "         \ | call setwinvar(winnr(), '&ruler', b:ruler)
  "         \ | call setwinvar(winnr(), '&showmode', b:showmode)
  "       setlocal laststatus=0 noshowmode noruler
  "     endfunction
  "     autocmd! FileType fzf call <SID>on_fzf()
  "   augroup END
  
  Plug 'tomtom/tcomment_vim'
    autocmd FileType * setlocal formatoptions-=ro

  Plug 'junegunn/vim-easy-align'

  Plug 'jiangmiao/auto-pairs'
  Plug 'ConradIrwin/vim-bracketed-paste'

  Plug 'ludovicchabant/vim-gutentags'
    let g:gutentags_ctags_tagfile = ".tags"

  Plug 'majutsushi/tagbar'

  Plug 'arcticicestudio/nord-vim'
    let g:nord_bold_vertical_split_line = v:true
    let g:nord_uniform_diff_background  = v:true

  Plug 'chrisbra/Colorizer'

  Plug 'nvim-lua/plenary.nvim'
  Plug 'lewis6991/gitsigns.nvim'
  Plug 'famiu/feline.nvim'

  " Plug 'itchyny/lightline.vim'
  "   set noshowmode
  "
  "   let g:lightline = {
  "     \   'colorscheme': 'nord',
  "     \   'active': {
  "     \     'left': [
  "     \       ['mode', 'paste'],
  "     \       ['gitbranch', 'filename'],
  "     \      ],
  "     \      'right': [
  "     \        ['readonly'],
  "     \        ['fileformat', 'fileencoding', 'lineinfo'],
  "     \        ['lsp_progress', 'lsp_errors', 'lsp_warnings', 'lsp_ok'],
  "     \      ],
  "     \   },
  "     \   'inactive': {
  "     \     'left': [
  "     \       ['filename'],
  "     \     ],
  "     \     'right': [
  "     \       ['lineinfo'],
  "     \     ],
  "     \   },
  "     \   'component': {
  "     \     'lineinfo': '%3l:%-2v',
  "     \   },
  "     \   'component_expand': {
  "     \     'readonly':     'LightlineReadonly',
  "     \     'lsp_warnings': 'LightlineLSPWarnings',
  "     \     'lsp_errors':   'LightlineLSPErrors',
  "     \     'lsp_ok':       'LightlineLSPOk',
  "     \     'lsp_progress': 'LighlineLSPProgress',
  "     \   },
  "     \   'component_type': {
  "     \     'readonly':     'error',
  "     \     'lsp_warnings': 'warning',
  "     \     'lsp_errors':   'error',
  "     \     'lsp_ok':       'middle',
  "     \   },
  "     \   'component_function': {
  "     \     'gitbranch':    'fugitive#head',
  "     \     'filename':     'LightlineFilename',
  "     \     'fileformat':   'LightlineFileformat',
  "     \     'filetype':     'LightlineFiletype',
  "     \     'fileencoding': 'LightlineFileencoding'
  "     \   },
  "     \   'separator':    { 'left': '',  'right': ''  },
  "     \   'subseparator': { 'left': '|', 'right': '|' },
  "     \   'mode_map': {
  "     \     'n':      'N',
  "     \     'i':      'I',
  "     \     'R':      'R',
  "     \     'v':      'V',
  "     \     'V':      'VL',
  "     \     "\<C-v>": 'VB',
  "     \     'c':      'C',
  "     \     's':      'S',
  "     \     'S':      'SL',
  "     \     "\<C-s>": 'SB',
  "     \     't':      'T',
  "     \   },
  "     \ }
  "
  "   function! LightlineFilename()
  "     let filename = expand('%:t')
  "     return (filename ==# '' ? '[No Name]' : filename) . (&modified ? ' +' : '')
  "   endfunction
  "
  "   function! LightlineReadonly()
  "     return &readonly && &buftype != 'help' && &filetype != 'netrw' ? 'RO' : ''
  "   endfunction
  "
  "   function! LightlineFileformat()
  "     return winwidth(0) > 70 ? &fileformat : ''
  "   endfunction
  "
  "   function! LightlineFiletype()
  "     return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
  "   endfunction
  "
  "   function! LightlineFileencoding()
  "     return winwidth(0) > 70 ? &fileencoding : ''
  "   endfunction
  "
  "   function! LightlineLSPWarnings() abort
  "     let l:counts = lsp#get_buffer_diagnostics_counts()
  "     return l:counts.warning == 0 ? '' : printf('W:%d', l:counts.warning)
  "   endfunction
  "
  "   function! LightlineLSPErrors() abort
  "     let l:counts = lsp#get_buffer_diagnostics_counts()
  "     return l:counts.error == 0 ? '' : printf('E:%d', l:counts.error)
  "   endfunction
  "
  "   function! LightlineLSPOk() abort
  "     let l:counts =  lsp#get_buffer_diagnostics_counts()
  "     let l:total = l:counts.error + l:counts.warning
  "     return l:total == 0 ? 'OK' : ''
  "   endfunction
  "
  "   function! LightlineLSPProgress() abort
  "     let l:progress = lsp#get_progress()
  "     if empty(l:progress) | return '' | endif
  "     let l:progress = l:progress[len(l:progress) - 1]
  "     return l:progress['server'] . ': ' . l:progress['message']
  "   endfunction
  "
  "   augroup LightLineOnLSP | autocmd!
  "     autocmd User lsp_diagnostics_updated call lightline#update()
  "     autocmd User lsp_progress_updated call lightline#update()
  "   augroup END

  Plug 'Yggdroot/indentLine'
    let g:indentLine_color_term    = 0
    let g:indentLine_bgcolor_term  = 'NONE'
    let g:indentLine_color_gui     = '#3b4252'
    let g:indentLine_bgcolor_gui   = 'NONE'
    let g:indentLine_concealcursor = 0

    augroup IndentLineOnFZF | autocmd!
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

let g:nord_colors = NordPalette()
set termguicolors
highlight link TelescopeSelection Visual
highlight TelescopeSelectionCaret ctermfg=6 guifg=g:nord_colors['nord8']
highlight link TelescopeMatching String
highlight link TelescopePromptPrefix Comment

highlight LspReferenceText cterm=underline gui=underline

lua << EOF
local lsp = require('feline.providers.lsp')

local nord_colors = vim.api.nvim_get_var('nord_colors')
local vi_mode_utils = require('feline.providers.vi_mode')
require('feline').setup({
  components = {
    left = {
      active = {
        {
          provider = 'vi_mode',
          hl = function()
            local val = {}

            val.name = vi_mode_utils.get_mode_highlight_name()
            val.fg = vi_mode_utils.get_mode_color()
            val.style = 'bold'

            return val
          end,
          icon = '',
          right_sep = ' ',
        }, {
          provider = 'file_info',
          type = 'unique-short',
          icon = '',
          file_modified_icon = '+',
          -- left_sep = 
        }
      },
      inactive = {}
    },
    mid = {
      active = {},
      inactive = {}
    },
    right = {
      active = {
        {
          provider = 'git_branch',
          right_sep = ' ',
          icon = '',
          hl = {},
        }, {
          provider = 'diagnostics_info',
          enabled = function() return lsp.diagnostics_exist('Information') end,
          icon = 'I',
          hl = {fg = 'nord7'},
        }, {
          provider = 'diagnostics_hints',
          enabled = function() return lsp.diagnostics_exist('Hint') end,
          icon = 'H',
          hl = {fg = 'nord8'},
        }, {
          provider = 'diagnostics_warnings',
          enabled = function() return lsp.diagnostics_exist('Warning') end,
          icon = 'W',
          hl = {fg = 'nord13'},
        }, {
          provider = 'diagnostic_errors',
          enabled = function() return lsp.diagnostics_exist('Error') end,
          icon = 'E',
          left_sep = {str = ' ', hl = {bg = 'nord11'}},
          right_sep = {str = ' ', hl = {bg = 'nord11'}},
          hl = {bg = 'nord11'},
        }, {
          provider = 'position',
          left_sep  = ' ',
          right_sep = ' ',
          hl = {},
        }, {
          provider = 'line_percentage',
          left_sep  = ' ',
          right_sep = ' ',
          hl = {},
        }, {
          provider = 'scroll_bar',
          hl = {},
        }
      },
      inactive = {}
    },
  },
  default_bg = 'nord1',
  default_fg = 'nord6',
  colors = {
    nord0  = nord_colors['nord0'],
    nord1  = nord_colors['nord1'],
    nord2  = nord_colors['nord2'],
    nord3  = nord_colors['nord3'],
    nord4  = nord_colors['nord4'],
    nord5  = nord_colors['nord5'],
    nord6  = nord_colors['nord6'],
    nord7  = nord_colors['nord7'],
    nord8  = nord_colors['nord8'],
    nord9  = nord_colors['nord9'],
    nord10 = nord_colors['nord10'],
    nord11 = nord_colors['nord11'],
    nord12 = nord_colors['nord12'],
    nord13 = nord_colors['nord13'],
    nord14 = nord_colors['nord14'],
    nord15 = nord_colors['nord15'],
  },
  vi_mode_colors = {
    NORMAL        = 'nord6',
    OP            = 'nord8',
    INSERT        = 'nord8',
    VISUAL        = 'nord7',
    BLOCK         = 'nord7',
    REPLACE       = 'nord15',
    ['V-REPLACE'] = 'nord15',
    ENTER         = 'nord8',
    MORE          = 'nord8',
    SELECT        = 'nord12',
    COMMAND       = 'nord7',
    SHELL         = 'nord7',
    TERM          = 'nord7',
    NONE          = 'nord13',
  },
})

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t '<C-n>'
  elseif check_back_space() then
    return t '<Tab>'
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t '<C-p>'
  else
    return t '<S-Tab>'
  end
end

local on_lsp_attach = function(client, bufnr)
  local map = function(type, key, value, opts)
    vim.api.nvim_buf_set_keymap(bufnr, type, key, value, opts)
  end

  local set_option = function(key, value)
    vim.api.nvim_buf_set_option(bufnr, key, value)
  end

  set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  map('n', '<C-]>',      "<Cmd>lua require('telescope.builtin').lsp_definitions()<CR>",     {noremap = true, silent = true})
  map('n', '<Leader>lu', "<Cmd>lua require('telescope.builtin').lsp_references()<CR>",     {noremap = true, silent = true})
  map('n', '<Leader>li', "<Cmd>lua require('telescope.builtin').lsp_implementations()<CR>", {noremap = true, silent = true})
  map('n', '<Leader>la', "<Cmd>lua require('telescope.builtin').lsp_code_actions()<CR>",    {noremap = true, silent = true})
  map('n', '<Leader>lr', '<Cmd>lua vim.lsp.buf.rename()<CR>',         {noremap = true, silent = true})
  map('n', '<Leader>lh', '<Cmd>lua vim.lsp.buf.hover()<CR>',          {noremap = true, silent = true})

  if client.resolved_capabilities.document_formatting then
    map('n', '<Leader>lf', '<Cmd>lua vim.lsp.buf.formatting()<CR>', {noremap = true, silent = true})
  end
  if client.resolved_capabilities.document_range_formatting then
    map('v', '<Leader>lf', '<Cmd>lua vim.lsp.buf.range_formatting()<CR>', {noremap = true, silent = true})
  end

  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      autocmd CursorHold,CursorHoldI   <buffer> lua vim.lsp.buf.document_highlight()
      autocmd CursorMoved,CursorMovedI <buffer> lua vim.lsp.buf.clear_references()
    ]], true)
  end

  require('compe').setup({
    enabled = true;
    autocomplete = true;
    debug = false;
    min_length = 1;
    preselect = 'disable';
    throttle_time = 80;
    source_timeout = 200;
    incomplete_delay = 400;
    max_abbr_width = 100;
    max_kind_width = 100;
    max_menu_width = 100;
    documentation = true;

    source = {
      path = true;
      nvim_lsp = true;
    };
  })

  map('i', '<Tab>', 'v:lua.tab_complete()', {expr = true, silent = true})
  map('s', '<Tab>', 'v:lua.tab_complete()', {expr = true, silent = true})
  map('i', '<S-Tab>', 'v:lua.s_tab_complete()', {expr = true, silent = true})
  map('s', '<-STab>', 'v:lua.s_tab_complete()', {expr = true, silent = true})

  map('i', '<CR>', 'compe#confirm("<CR>")', {expr = true, silent = true})
  map('i', '<C-Space>', 'compe#complete()', {expr = true, silent = true})
  map('i', '<C-e>', 'compe#close("<C-e>")', {expr = true, silent = true})
end

local servers = {
  'gopls',
}

local lspconfig = require('lspconfig')
for _, s in ipairs(servers) do
  lspconfig[s].setup({
    on_attach = on_lsp_attach
  })
end

require('telescope').setup({
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
    prompt_prefix = "> ",
    selection_caret = "> ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "ascending",
    layout_strategy = "flex",
    layout_config = {
      horizontal = {
        prompt_position = "top",
      },
      vertical = {},
    },
    file_sorter =  require('telescope.sorters').get_fuzzy_file,
    generic_sorter =  require('telescope.sorters').get_generic_fuzzy_sorter,
    winblend = 0,
    mappings = {
      i = {
        ["<Esc>"] = require('telescope.actions').close,
      }
    },
    border = {},
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    color_devicons = false,
    use_less = true,
    path_display = {},
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = require('telescope.previewers').vim_buffer_cat.new,
    grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
    qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,

    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require('telescope.previewers').buffer_previewer_maker
  },
})
EOF
