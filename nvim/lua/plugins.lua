local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd 'packadd packer.nvim'
end

require('packer').startup(function(use)
  use { 'wbthomason/packer.nvim', opt = true }
  use {
    'airblade/vim-rooter',
    commit = '0415be8b5989e56f6c9e382a04906b7f719cfb38',
    setup = function()
      vim.g.rooter_targets = '*'
      vim.g.rooter_silent_chdir = true
      vim.g.rooter_patters = {'.git', '.git/'}
      vim.g.rooter_resolve_links = true
    end
  }
  use {'sheerun/vim-polyglot'}
  -- TODO: https://github.com/windwp/nvim-autopairs
  -- use {
  --   'jiangmiao/auto-pairs',
  --   as = 'auto-pairs',
  --   setup = function()
  --     vim.g.AutoPairsMapBS = false
  --     vim.g.AutoPairsCenterLine = false
  --   end
  -- }
  use {
    'ConradIrwin/vim-bracketed-paste',
    commit = '45411da73cc159e4fc2138d930553d247bbfbcdc',
  }
  use {'tomtom/tcomment_vim'}
  use {
    'arcticicestudio/nord-vim',
    tag = '0.19.0',
    as = 'nord',
    setup = function()
      vim.g.nord_bold_vertical_split_line = true
      vim.g.nord_uniform_diff_background  = true
    end,
    config = function()
      vim.api.nvim_exec('colorscheme nord', true)
      vim.o.termguicolors = true
      -- fix: remove background highlighting of Diff* groups
      for _,g in ipairs({'DiffAdd', 'DiffChange', 'DiffDelete'}) do
        vim.highlight.create(g, {ctermbg='NONE', guibg='NONE'}, false)
      end

      _G.nord_colors = vim.fn['NordPalette']()
    end,
  }
  use {'chrisbra/Colorizer'}
  -- use {
  --   'Yggdroot/indentLine',
  --   after = {
  --     'nord',
  --   },
  --   config = function()
  --     vim.g.indentLine_color_term    = 0
  --     vim.g.indentLine_bgcolor_term  = 'NONE'
  --     vim.g.indentLine_color_gui     = _G.nord_colors['nord0']
  --     vim.g.indentLine_bgcolor_gui   = 'NONE'
  --     vim.g.indentLine_concealcursor = 0
  --   end
  -- }
  use {
    'lukas-reineke/indent-blankline.nvim',
    tag = 'v2.18.4',
    config = function()
      require('indent_blankline').setup({
        char = '|',
        show_first_indent_level        = false,
        show_trailing_blankline_indent = false,
      })
      -- vim.api.nvim_create_autocmd({''})
      -- TODO
      -- vim.api.nvim_exec('autocmd CursorMoved,CursorMovedI * IndentBlanklineRefresh', true)
    end,
  }

  use {
    'lewis6991/gitsigns.nvim',
    -- commit = '27aeb2e715c32cbb99aa0b326b31739464b61644',
    as = 'gitsigns',
    config = function()
      require('gitsigns').setup({
        signs = {
          add           = {text = '+'},
          change        = {text = '~'},
          delete        = {text = '_'},
          topdelte      = {text = '‾'},
          chandedelete  = {text = '≈'},
        },
        signcolumn = true,
        numhl      = false,
        linehl     = false,
      })
      vim.api.nvim_set_keymap('n', '<Leader>g?',
        "<Cmd>lua require('gitsigns').toggle_current_line_blame()<CR>",
        {noremap = true, silent=true})
    end
  }

  use {
    'feline-nvim/feline.nvim',
    tag = 'v1.1.3',
    after = {
      'nord',
      'gitsigns',
    },
    config = function()
      local vi_mode = require('feline.providers.vi_mode')

      local cursor = {}
      function cursor.position()
        return string.format('%3d:%-2d', vim.fn.line('.'), vim.fn.col('.'))
      end
      function cursor.line_percentage()
        local cur = vim.fn.line('.')
        local total = vim.fn.line('$')

        return string.format('%2d%%%%', vim.fn.round(cur / total * 100))
      end

      local file = {}
      function file.file_type()
        return vim.bo.filetype:upper()
      end
      function file.file_encoding()
        local enc = (vim.bo.fenc ~= '' and vim.bo.fenc) or vim.o.enc
        return enc:upper()
      end

      local lsp = {}
      function lsp.is_attached()
        return next(vim.lsp.buf_get_clients()) ~= nil
      end

      local mode = {}
      function mode.short_name()
        local mode = vi_mode.get_vim_mode()
        if mode == 'NORMAL' then
          return 'N'
        elseif mode == 'INSERT' then
          return 'I'
        elseif mode == 'VISUAL' then
          return 'V'
        elseif mode == 'REPLACE' then
          return 'R'
        elseif mode == 'COMMAND' then
          return 'C'
        end
        return mode
      end
      function mode.hl()
        local mode_colors = {
          INSERT  = {bg = 'nord8', fg = 'nord0'},
          VISUAL  = {bg = 'nord7', fg = 'nord0'},
          COMMAND = {bg = 'nord10'}
        }
        return mode_colors[vi_mode.get_vim_mode()] or {}
      end

      require('feline').setup({
        preset = 'noicon',
        components = {
          active = {
            { -- left
              {
                provider = mode.short_name,
                --hl = mode.hl,
                left_sep = {
                  str = ' ',
                  --hl = mode.hl,
                },
                right_sep = {
                  str = ' ',
                  --hl = mode.hl,
                },
              }, {
                provider = function()
                  return vim.b.gitsigns_head
                end,
                enabled = function()
                  return vim.b.gitsigns_head ~= nil
                end,
                left_sep = {
                  str = '[',
                  hl = {},
                },
                right_sep = {
                  str = '] ',
                  hl = {},
                },
                hl = {},
              }, {
                provider = 'file_info',
                icon = '',
                opts = {
                  type = 'unique-short',
                  colored_icon = false,
                  file_modified_icon = '*',
                  file_readonly_icon = '[RO]',
                },
              }, {
                provider = function()
                  return vim.b.gitsigns_status
                end,
                enabled = function()
                  return vim.b.gitsigns_status ~= nil
                end,
                left_sep = {
                  str = ' (',
                },
                right_sep = {
                  str = ') ',
                },
              },
            }, -- end(left)
            { -- right
              {
                provider = function() return 'i' ..
                  #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.INFO}) end,
                enabled =  function() return
                  #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.INFO}) > 0 end,
                left_sep = {
                  str = ' ',
                  hl = {bg = 'nord7'},
                },
                right_sep = {
                  str = ' ',
                  hl = {bg = 'nord7'},
                },
                hl = {bg = 'nord7', fg = 'nord0'},
              }, {
                provider = function() return 'H' ..
                  #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.HINT}) end,
                enabled =  function() return
                  #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.HINT}) > 0 end,
                left_sep = {
                  str = ' ',
                  hl = {bg = 'nord8'},
                },
                right_sep = {
                  str = ' ',
                  hl = {bg = 'nord8'},
                },
                hl = {bg = 'nord8', fg = 'nord0'},
              }, {
                provider = function() return 'W' ..
                  #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.WARN}) end,
                enabled =  function() return
                  #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.WARN}) > 0 end,
                left_sep = {
                  str = ' ',
                  hl = {bg = 'nord13'},
                },
                right_sep = {
                  str = ' ',
                  hl = {bg = 'nord13'},
                },
                hl = {bg = 'nord13', fg = 'nord0'},
              }, {
                provider = function() return 'E' ..
                  #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.ERROR}) end,
                enabled =  function() return
                  #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.ERROR}) > 0 end,
                left_sep = {
                  str = ' ',
                  hl = {bg = 'nord11'},
                },
                right_sep = {
                  str = ' ',
                  hl = {bg = 'nord11'},
                },
                hl = {bg = 'nord11'},
              }, {
                provider = function ()
                  local names = {}
                  for _, client in pairs(vim.lsp.buf_get_clients()) do
                    names[#names+1] = client.name
                  end
                  return table.concat(names, ', ')
                end,
                enabled = lsp.is_attached,
                left_sep = {
                  str = ' ',
                  hl = {bg = 'nord3'},
                },
                right_sep = {
                  str = ' ',
                  hl = {bg = 'nord3'},
                },
                hl = {bg = 'nord3'},
              }, {
                provider = file.file_encoding,
                left_sep = '(',
                right_sep = ')',
              }, {
                provider = cursor.position,
                left_sep = ' ',
                right_sep = ' ',
              }, {
                provider = cursor.line_percentage,
                left_sep = ' ',
                right_sep = ' ',
              }, {
                provider = 'scroll_bar',
                left_sep = ' ',
                hl = {},
              },
            }, -- end(right)
          },
          inactive = {
            { -- left
              {
                provider = 'file_info',
                icon = '',
                opts = {
                  type = 'unique-short',
                  colored_icon = false,
                  file_modified_icon = '*',
                  file_readonly_icon = '[RO]',
                  hl = {bg = 'nord0', fg = 'nord3'},
                },
              },
            }, -- end(left)
            { -- right
              {
                provider = cursor.position,
                left_sep = ' ',
                right_sep = ' ',
              }, {
                provider = cursor.line_percentage,
                left_sep = ' ',
                right_sep = ' ',
              }, {
                provider = 'scroll_bar',
                left_sep = ' ',
                hl = {},
              },
            }, -- end(right)
          },
        },
        theme = {
          bg     = _G.nord_colors['nord1'],
          fg     = _G.nord_colors['nord6'],
          nord0  = _G.nord_colors['nord0'],
          nord1  = _G.nord_colors['nord1'],
          nord2  = _G.nord_colors['nord2'],
          nord3  = _G.nord_colors['nord3'],
          nord4  = _G.nord_colors['nord4'],
          nord5  = _G.nord_colors['nord5'],
          nord6  = _G.nord_colors['nord6'],
          nord7  = _G.nord_colors['nord7'],
          nord8  = _G.nord_colors['nord8'],
          nord9  = _G.nord_colors['nord9'],
          nord10 = _G.nord_colors['nord10'],
          nord11 = _G.nord_colors['nord11'],
          nord12 = _G.nord_colors['nord12'],
          nord13 = _G.nord_colors['nord13'],
          nord14 = _G.nord_colors['nord14'],
          nord15 = _G.nord_colors['nord15'],
        },
      })
      vim.o.showmode = false
    end,
  }

  use {
    'nvim-telescope/telescope.nvim',
    as = 'telescope',
    requires = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
    },
    after = {
      'nord',
    },
    config = function()
      local sorters = require('telescope.sorters')
      local actions = require('telescope.actions')
      local previewers = require('telescope.previewers')

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
          file_sorter = sorters.get_fuzzy_file,
          generic_sorter =  sorters.get_generic_fuzzy_sorter,
          winblend = 0,
          mappings = {
            i = {
              ["<Esc>"] = actions.close,
            }
          },
          border = {},
          borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
          color_devicons = false,
          use_less = true,
          path_display = {},
          set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
          file_previewer   = previewers.vim_buffer_cat.new,
          grep_previewer   = previewers.vim_buffer_vimgrep.new,
          qflist_previewer = previewers.vim_buffer_qflist.new,

          -- Developer configurations: Not meant for general override
          buffer_previewer_maker = previewers.buffer_previewer_maker,
        }
      })

      local map = vim.api.nvim_set_keymap

      map('n', '<Leader>ff', "<Cmd>lua require('telescope.builtin').find_files()<CR>",               {noremap = true, silent = true})
      map('n', '<Leader>fg', "<Cmd>lua require('telescope.builtin').live_grep()<CR>",                {noremap = true, silent = true})
      map('n', '<Leader>fc', "<Cmd>lua require('telescope.builtin').current_buffer_lazy_find()<CR>", {noremap = true, silent = true})
      map('n', '<Leader>fb', "<Cmd>lua require('telescope.builtin').buffers()<CR>",                  {noremap = true, silent = true})
      map('n', '<Leader>ft', "<Cmd>lua require('telescope.builtin').file_browser()<CR>",             {noremap = true, silent = true})

      map('n', '<Leader>gc', "<Cmd>lua require('telescope.builtin').git_commits()<CR>",              {noremap = true, silent = true})
      map('n', '<Leader>gb', "<Cmd>lua require('telescope.builtin').git_branches()<CR>",             {noremap = true, silent = true})

      map('n', '<Leader>va', "<Cmd>lua require('telescope.builtin').autocommands()<CR>",             {noremap = true, silent = true})
      map('n', '<Leader>vh', "<Cmd>lua require('telescope.builtin').highlights()<CR>",               {noremap = true, silent = true})
      map('n', '<Leader>vm', "<Cmd>lua require('telescope.builtin').man_pages()<CR>",                {noremap = true, silent = true})

      vim.api.nvim_exec('autocmd User TelescopePreviewLoaded setlocal wrap', true)

      vim.api.nvim_exec([[
        highlight link TelescopeSelection Visual
        highlight TelescopeSelectionCaret ctermfg=6 guifg=g:nord_colors['nord8']
        highlight link TelescopeMatching String
        highlight link TelescopePromptPrefix Comment
      ]], true)
    end,
  }

  use {
    'hrsh7th/nvim-compe',
    as = 'compe',
    config = function()
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
    end,
  }

  use {
    'nvim-lua/lsp_extensions.nvim',
    as = 'lsp_extensions',
  }

  use {
    'neovim/nvim-lspconfig',
    as = 'lspconfig',
    after = {
      'nord',
      'compe',
      'lsp_extensions',
      'telescope',
    },
    config = function()
      local on_lsp_attach = function(client, bufnr)
        vim.api.nvim_exec('highlight LspReferenceText cterm=underline gui=underline', true)

        local root = vim.lsp.buf.list_workspace_folders()[1]
        if root ~= nil then
          vim.api.nvim_exec('lcd '..root, true)
        end

        local map = function(mode, key, value, opts)
          vim.api.nvim_buf_set_keymap(bufnr, mode, key, value, opts)
        end

        vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'

        map('n', '<C-]>',      "<Cmd>lua require('telescope.builtin').lsp_definitions()<CR>",     {noremap = true, silent = true})
        map('n', '<Leader>lu', "<Cmd>lua require('telescope.builtin').lsp_references()<CR>",      {noremap = true, silent = true})
        map('n', '<Leader>li', "<Cmd>lua require('telescope.builtin').lsp_implementations()<CR>", {noremap = true, silent = true})
        map('n', '<Leader>la', "<Cmd>lua require('telescope.builtin').lsp_code_actions()<CR>",    {noremap = true, silent = true})
        map('n', '<Leader>lr', '<Cmd>lua vim.lsp.buf.rename()<CR>',                               {noremap = true, silent = true})
        map('n', '<Leader>lh', '<Cmd>lua vim.lsp.buf.hover()<CR>',                                {noremap = true, silent = true})

        if client.resolved_capabilities.document_formatting then
          map('n', '<Leader>lf', '<Cmd>lua vim.lsp.buf.formatting()<CR>', {noremap = true, silent = true})
        end
        if client.resolved_capabilities.document_range_formatting then
          map('v', '<Leader>lf', '<Cmd>lua vim.lsp.buf.range_formatting()<CR>', {noremap = true, silent = true})
        end

        -- TODO: map to highlight references
        -- if client.resolved_capabilities.document_highlight then
        --   vim.api.nvim_exec([[
        --     autocmd CursorHold,CursorHoldI   <buffer> lua vim.lsp.buf.document_highlight()
        --     autocmd CursorMoved,CursorMovedI <buffer> lua vim.lsp.buf.clear_references()
        --   ]], true)
        -- end

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

        map('i', '<Tab>',   'v:lua.tab_complete()',   {expr = true, silent = true})
        map('s', '<Tab>',   'v:lua.tab_complete()',   {expr = true, silent = true})
        map('i', '<S-Tab>', 'v:lua.s_tab_complete()', {expr = true, silent = true})
        map('s', '<-STab>', 'v:lua.s_tab_complete()', {expr = true, silent = true})

        map('i', '<CR>',      'compe#confirm("<CR>")', {expr = true, silent = true})
        map('i', '<C-Space>', 'compe#complete()',      {expr = true, silent = true})
        map('i', '<C-e>',     'compe#close("<C-e>")',  {expr = true, silent = true})
      end

      local servers = {
        clangd = {
          cmd = { 'clangd', '--background-index', '--enable-config' },
        },
        gopls = {
          settings = {
            gopls = {
              analyses = {
                fieldalignment = true,
                nilness        = true,
                unusedparams   = true,
                unusedwrite    = true,
              },
            },
          },
        },
        pyright = {},
        rust_analyzer = {
          settings = {
            ['rust-analyzer'] = {
              assist = {
                importGranularity = "module",
                importPrefix      = "by_self",
              },
            },
          },
        },
      }

      local lspconfig = require('lspconfig')
      for s, cfg in pairs(servers) do
        cfg.on_attach = on_lsp_attach
        lspconfig[s].setup(cfg)
      end

      require('lsp_extensions').inlay_hints({
        prefix = '=>',
        highlight = 'Comment',
        enabled = {
          'TypeHint',
          'ParameterHint',
        },
      })
    end
  }

  -- use {
  --   'simrat39/rust-tools.nvim',
  --   after = {
  --     'lspconfig',
  --     'telescope',
  --   },
  --   config = function()
  --     require('rust-tools').setup({})
  --   end,
  -- }

  use {
    'fatih/vim-go',
    run = ':GoUpdateBinaries',
    ft = {'go', 'gomod'},
    setup = function()
      vim.g.go_code_completion_enabled = false
      vim.g.go_fmt_autosave            = false
      vim.g.go_imports_autosave        = false
      vim.g.go_mod_fmt_autosave        = false
      vim.g.go_def_mapping_enabled     = false
      vim.g.go_gopls_enabled           = false
      vim.g.go_echo_command_info       = false
      vim.g.go_echo_go_info            = false
      vim.g.go_fold_enable             = {}

      vim.g.go_highlight_array_whitespace_error    = true
      vim.g.go_highlight_chan_whitespace_error     = true
      vim.g.go_highlight_extra_types               = true
      vim.g.go_highlight_space_tab_error           = true
      vim.g.go_highlight_trailing_whitespace_error = true
      vim.g.go_highlight_operators                 = true
      vim.g.go_highlight_functions                 = true
      vim.g.go_highlight_function_parameters       = true
      vim.g.go_highlight_function_calls            = true
      vim.g.go_highlight_types                     = true
      vim.g.go_highlight_fields                    = true
      vim.g.go_highlight_build_constraints         = true
      vim.g.go_highlight_generate_tags             = true
      vim.g.go_highlight_string_spellcheck         = true
      vim.g.go_highlight_format_strings            = true
      vim.g.go_highlight_variable_declarations     = true
      vim.g.go_highlight_variable_assignments      = true
      vim.g.go_highlight_diagnostic_errors         = false
      vim.g.go_highlight_diagnostic_warnings       = false
    end,
  }
end)
