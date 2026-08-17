vim.pack.add({
  'https://github.com/sudo-tee/opencode.nvim',
})

require('opencode').setup({
  preferred_picker = 'snacks',
  default_global_keymaps = false,
  -- context = {
  --   current_file = {
  --     enabled = false,
  --   },
  -- },
  -- debug = {
  --   highlight_changed_lines = true,
  --   highlight_changed_lines_timeout_ms = 1200,
  -- },
  keymap = {
    input_window = {
      ['<tab>'] = { 'switch_mode', mode = { 'n', 'i' }, desc = 'Switch agent mode' },
      ['q'] = { 'close', mode = { 'n' }, desc = 'Close opencode' },
      ['<M-v>'] = false,
      ['<C-v>'] = { 'paste_image', mode = { 'i' }, desc = 'Paste image from clipboard' },
    },
    output_window = {
      ['<tab>'] = { 'switch_mode', mode = { 'n' }, desc = 'Switch agent mode' },
      ['q'] = { 'close', mode = { 'n' }, desc = 'Close opencode' },
    },
  },
})

vim.keymap.set('n', '<leader>ac', function()
  require('opencode.api').toggle()
end, { desc = 'Toggle opencode' })

vim.keymap.set('x', '<leader>ac', function()
  require('opencode.api').add_visual_selection()
end, { desc = 'Add selection to opencode' })
