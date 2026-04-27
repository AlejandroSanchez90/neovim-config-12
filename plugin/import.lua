vim.pack.add({
  'https://github.com/folke/snacks.nvim',
  'https://github.com/piersolenski/import.nvim',
})

require('import').setup({
  picker = 'snacks',
})

vim.keymap.set('n', '<leader>fi', function()
  require('import').pick()
end, { desc = 'Import' })
