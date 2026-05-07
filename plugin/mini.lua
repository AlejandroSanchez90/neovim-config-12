vim.pack.add(
  {
    'https://github.com/nvim-mini/mini.nvim'
  }
)
-- require('mini.files').setup()
-- require('mini.pairs').setup()



require('mini.ai').setup({ n_lines = 1500 })

require('mini.operators').setup({
  evaluate = { prefix = '<leader>o=' },
  exchange = { prefix = '<leader>ox', reindent_linewise = true },
  multiply = { prefix = '<leader>om' },
  replace = { prefix = '<leader>or', reindent_linewise = true },
  sort = { prefix = '<leader>os' },
})
vim.keymap.set('x', 'm', function()
  require('mini.operators').multiply('visual')
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

require('mini.clue').setup({
  window = {
    delay = 250,
  },
  triggers = {
    { mode = 'n', keys = '<leader>' },
    { mode = 'x', keys = '<leader>' },
    { mode = 'n', keys = 'g' },
    { mode = 'n', keys = 'z' },
    { mode = 'n', keys = '<C-w>' },
  },
  clues = {
    { mode = { 'n', 'x' }, keys = '<leader>a', desc = '+AI/Copilot' },
    { mode = { 'n', 'x' }, keys = '<leader>b', desc = '+Buffers' },
    { mode = { 'n', 'x' }, keys = '<leader>f', desc = '+Find' },
    { mode = { 'n', 'x' }, keys = '<leader>g', desc = '+Git' },
    { mode = { 'n', 'x' }, keys = '<leader>n', desc = '+Notes' },
    { mode = { 'n', 'x' }, keys = '<leader>o', desc = '+Operators' },
    { mode = { 'n', 'x' }, keys = '<leader>r', desc = '+Refactor/Rename' },
    { mode = { 'n', 'x' }, keys = '<leader>s', desc = '+Search/Surround' },
    { mode = { 'n', 'x' }, keys = '<leader>t', desc = '+Terminal' },
    { mode = { 'n', 'x' }, keys = '<leader>w', desc = '+Windows' },
    require('mini.clue').gen_clues.builtin_completion(),
    require('mini.clue').gen_clues.g(),
    require('mini.clue').gen_clues.marks(),
    require('mini.clue').gen_clues.registers(),
    require('mini.clue').gen_clues.windows(),
    require('mini.clue').gen_clues.z(),
  },
})

require('mini.files').setup({
  mappings = {
    close       = 'q',
    go_in       = 'l',
    go_in_plus  = '<CR>',
    go_out      = 'h',
    go_out_plus = 'H',
    mark_goto   = "'",
    mark_set    = 'm',
    reset       = '<BS>',
    reveal_cwd  = '_',
    show_help   = 'g?',
    synchronize = '<C-s>',
    trim_left   = '<',
    trim_right  = '>',
  },

})


local explore_at_file = '<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>'
vim.keymap.set("n", "<leader>e", explore_at_file, { desc = "Toggle files explorer" })
