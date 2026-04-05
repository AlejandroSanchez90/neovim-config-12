vim.pack.add({ 'https://github.com/otavioschwanck/arrow.nvim' })

require('arrow').setup({
  show_icons = true,
  leader_key = "'",
  buffer_leader_key = 'm',
  separate_by_branch = true,
  per_buffer_config = {
    lines = 5,
  },
})

local persist = require('arrow.persist')

vim.keymap.set('n', 'H', persist.previous)
vim.keymap.set('n', 'L', persist.next)
vim.keymap.set('n', 'M', persist.toggle)

for i = 1, 5 do
  vim.keymap.set('n', '<leader>' .. i, function()
    persist.go_to(i)
  end, { desc = 'Go to Arrow file ' .. i })
end
