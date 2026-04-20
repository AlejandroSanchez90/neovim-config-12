vim.pack.add({
  'https://github.com/folke/snacks.nvim',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/obsidian-nvim/obsidian.nvim',
})

require('obsidian').setup({
  legacy_commands = false,
  note_id_func = require('obsidian.builtin').title_id,
  picker = {
    name = 'snacks.pick',
  },
  completion = {
    min_chars = 1,
  },
  ui = {
    enable = false,
  },
  workspaces = {
    {
      name = 'work',
      path = '~/vaults/work',
    },
    {
      name = 'personal',
      path = '~/vaults/personal',
    },
  },
})

vim.keymap.set('n', '<leader>nd', '<cmd>Obsidian today<CR>', { desc = 'Obsidian Create/Update Today Note' })
vim.keymap.set('n', '<leader>nn', function()
  local title = vim.fn.input('Note title: ')
  if title ~= nil and title ~= '' then
    vim.cmd('Obsidian new ' .. vim.fn.fnameescape(title))
  end
end, { desc = 'Obsidian New Named Note' })
vim.keymap.set('n', '<leader>nt', '<cmd>Obsidian tags<CR>', { desc = 'Obsidian Search for tags' })
vim.keymap.set('n', '<leader>nw', '<cmd>Obsidian workspace<CR>', { desc = 'Obsidian Select workspace' })
vim.keymap.set('n', '<leader>nf', '<cmd>Obsidian quick_switch<CR>', { desc = 'Obsidian Quick Switch' })
vim.keymap.set('n', '<leader>ns', '<cmd>Obsidian search<CR>', { desc = 'Obsidian Search' })
