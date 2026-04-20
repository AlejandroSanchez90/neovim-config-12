vim.pack.add({ 'https://github.com/lewis6991/gitsigns.nvim' })

local gitsigns = require('gitsigns')

gitsigns.setup({
  current_line_blame = true,
  current_line_blame_opts = { delay = 100 },
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
  on_attach = function(bufnr)
    local map = function(mode, l, r, opts)
      vim.keymap.set(mode, l, r, vim.tbl_extend('force', { buffer = bufnr }, opts or {}))
    end

    map('n', ']c', function()
      if vim.wo.diff then vim.cmd.normal({ ']h', bang = true })
      else gitsigns.nav_hunk('next') end
    end, { desc = 'Jump to next git change' })

    map('n', '[c', function()
      if vim.wo.diff then vim.cmd.normal({ '[h', bang = true })
      else gitsigns.nav_hunk('prev') end
    end, { desc = 'Jump to previous git change' })

    map('v', '<leader>hs', function()
      gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end, { desc = 'git stage hunk' })

    map('n', '<leader>hs', gitsigns.stage_hunk,  { desc = 'git stage hunk' })
    map('n', '<leader>hr', gitsigns.reset_hunk,   { desc = 'git reset hunk' })
    map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git stage buffer' })
    map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git reset buffer' })
    map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git preview hunk' })
    map('n', '<leader>hb', gitsigns.blame_line,   { desc = 'git blame line' })
    map('n', '<leader>hd', gitsigns.diffthis,     { desc = 'git diff against index' })
    map('n', '<leader>hD', function() gitsigns.diffthis('@') end, { desc = 'git diff against last commit' })
    map('n', '<leader>ht', gitsigns.toggle_current_line_blame, { desc = 'toggle git blame line' })
  end,
})
