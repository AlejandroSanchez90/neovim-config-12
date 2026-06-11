vim.pack.add({
  'https://github.com/folke/trouble.nvim',
})

require('trouble').setup({
  focus = true,
})

vim.keymap.set('n', '<leader>xq', function()
  vim.cmd('Trouble qflist toggle')
end, { desc = 'Quickfix (Trouble)' })

vim.keymap.set('n', '<leader>xl', function()
  vim.cmd('Trouble loclist toggle')
end, { desc = 'Location List (Trouble)' })

vim.keymap.set('n', '<leader>xx', function()
  vim.cmd('Trouble diagnostics toggle filter.buf=0')
end, { desc = 'Buffer Diagnostics (Trouble)' })

vim.keymap.set('n', '<leader>xX', function()
  vim.cmd('Trouble diagnostics toggle')
end, { desc = 'Diagnostics (Trouble)' })
