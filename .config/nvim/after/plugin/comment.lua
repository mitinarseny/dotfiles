vim.api.nvim_create_autocmd({'VimEnter'}, {
  once = true,
  callback = function()
    require('Comment').setup({mappings = false})

    local c = require('Comment.api')
    local K = vim.keymap.set

    K('n', '<M-/>', function()
      return ('<Plug>(comment_toggle_current_linewise%s)'):format(
        vim.v.count == 0 and '' or '_count')
    end, {expr = true, remap = true, silent = true})
    K('n', '<M-?>', function()
      return ('<Plug>(comment_toggle_current_blockwise%s)'):format(
        vim.v.count == 0 and '' or '_count')
    end, {expr = true, remap = true, silent = true})
    K('n', 'gc', '<Plug>(comment_toggle_linewise)')
    K('n', 'gb', '<Plug>(comment_toggle_blockwise)')
    K('v', '<M-/>', '<Plug>(comment_toggle_linewise_visual)')
    K('v', '<M-?>', '<Plug>(comment_toggle_blockwise_visual)')
  end,
})
