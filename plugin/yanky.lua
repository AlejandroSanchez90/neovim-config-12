vim.pack.add({ 'https://github.com/gbprod/yanky.nvim' })

require('yanky').setup()

vim.keymap.set({ 'n', 'x' }, 'p', '<Plug>(YankyPutAfter)')
vim.keymap.set({ 'n', 'x' }, 'P', '<Plug>(YankyPutBefore)')
vim.keymap.set({ 'n', 'x' }, 'gp', '<Plug>(YankyGPutAfter)')
vim.keymap.set({ 'n', 'x' }, 'gP', '<Plug>(YankyGPutBefore)')

vim.keymap.set('n', '<C-p>', '<Plug>(YankyPreviousEntry)')
vim.keymap.set('n', '<C-n>', '<Plug>(YankyNextEntry)')
