vim.pack.add({
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/esmuellert/codediff.nvim',
})

vim.keymap.set('n', '<leader>gf', '<cmd>CodeDiff history %<CR>', { desc = 'File History' })
vim.keymap.set('n', '<leader>gd', '<cmd>CodeDiff<CR>', { desc = 'Git Diff' })
