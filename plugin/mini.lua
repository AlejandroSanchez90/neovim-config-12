vim.pack.add(
  {
    'https://github.com/nvim-mini/mini.nvim'
  }
)
-- require('mini.files').setup()
-- require('mini.pairs').setup()


require('mini.diff').setup({
  view = {
    style = 'number',
  },
})

vim.keymap.set('n', '<leader>ht', MiniDiff.toggle_overlay, { desc = 'toggle diff overlay' })

require('mini.ai').setup({ n_lines = 1500 })

local miniOperators = require('mini.operators')
miniOperators.setup({
  evaluate = { prefix = '<leader>o=' },
  exchange = { prefix = '<leader>ox', reindent_linewise = true },
  multiply = { prefix = '<leader>om' },
  replace = { prefix = '<leader>or', reindent_linewise = true },
  sort = { prefix = '<leader>os' },
})
vim.keymap.set('x', 'm', function()
  miniOperators.multiply('visual')
end, { desc = 'MiniOperators: multiply', noremap = true, silent = true })

require('mini.surround').setup({
  mappings = {
    add = '<leader>s',
    delete = '<leader>sd',
    find = '',
    find_left = '',
    highlight = '',
    replace = '<leader>sr',
    update_n_lines = '',
    suffix_last = '',
    suffix_next = '',
  },
})
