vim.api.nvim_create_autocmd('UIEnter', {
  once = true,
  callback = function()
    vim.o.title = true
    vim.o.errorbells = false
    vim.o.visualbell = false
    vim.o.lazyredraw = true

    vim.o.mouse = 'a' -- enable mouse everywhere

    vim.o.number = true
    vim.o.cursorline = true
    vim.o.cursorlineopt = 'number'
    vim.o.list = true
    vim.opt.listchars = {
      tab = '| ',
      trail = '-',
      multispace = '.',
    }
    vim.opt.fillchars = {
      stl = ' ',
      stlnc = ' ',
    }

    vim.o.breakindent = true
    vim.o.breakindentopt = 'sbr'
    vim.o.showbreak = '~> '

    vim.o.splitright = true
    vim.o.splitbelow = true
    vim.o.equalalways = false

    vim.go.guicursor = 'n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20'

    vim.o.pumheight = 10

    if tonumber(vim.o.t_Co) > 1 then
      vim.cmd([[syntax enable]]) -- enable syntax highlighting if terminal supports colors
    end
    vim.o.cursorline = true
  end,
})
