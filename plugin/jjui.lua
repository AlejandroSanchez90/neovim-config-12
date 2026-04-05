vim.pack.add({
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/mrdwarf7/lazyjui.nvim',
})

-- lazyjui.lua does `return require("lazyjui")` — a self-referential re-export
-- that only works with lazy.nvim's custom loader. Load the actual module directly.
local lazyjui = require('lazyjui.init')
package.loaded['lazyjui'] = lazyjui

lazyjui.setup({
  border = {
    chars = { '', '', '', '', '', '', '', '' },
    thickness = 0,
    winhl_str = '',
  },
  cmd = { 'jjui' },
  height = 0.8,
  width = 0.9,
  winblend = 0,
  use_default_keymaps = true,
})

vim.keymap.set('n', '<leader>gj', function()
  lazyjui.open()
end, { desc = 'Open jjui' })
