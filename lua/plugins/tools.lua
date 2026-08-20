return {
  {
    'dmtrKovalenko/fff.nvim',
    lazy = false,
    dependencies = { 'folke/trouble.nvim' },
    build = function() require('fff.download').download_or_build_binary() end,
    config = function()
      require('fff').setup({ debug = { enabled = true, show_scores = true }, preview = { show_file_info = true }, git = { status_text_color = true } })
      local has_trouble = pcall(require, 'trouble')
      local picker_ok, picker_ui = pcall(require, 'fff.picker_ui')
      if has_trouble and picker_ok then
        local send_to_quickfix = picker_ui.send_to_quickfix
        picker_ui.send_to_quickfix = function(...)
          send_to_quickfix(...)
          vim.schedule(function()
            if #vim.fn.getqflist() == 0 then return end
            vim.cmd('silent! cclose')
            vim.cmd('Trouble qflist open')
          end)
        end
      end
      vim.keymap.set('n', '<leader><space>', function() require('fff').find_files() end, { desc = 'FFFind files' })
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile', 'BufFilePost', 'BufWritePost' },
    cmd = 'Gitsigns',
    opts = {
      current_line_blame = true,
      current_line_blame_opts = { delay = 100 },
      signs = { add = { text = '+' }, change = { text = '~' }, delete = { text = '_' }, topdelete = { text = '‾' }, changedelete = { text = '~' } },
      on_attach = function(bufnr)
        local gitsigns = require('gitsigns')
        local map = function(mode, lhs, rhs, opts) vim.keymap.set(mode, lhs, rhs, vim.tbl_extend('force', { buffer = bufnr }, opts or {})) end
        map('n', ']c', function() if vim.wo.diff then vim.cmd.normal({ ']h', bang = true }) else gitsigns.nav_hunk('next') end end, { desc = 'Jump to next git change' })
        map('n', '[c', function() if vim.wo.diff then vim.cmd.normal({ '[h', bang = true }) else gitsigns.nav_hunk('prev') end end, { desc = 'Jump to previous git change' })
        map('v', '<leader>hs', function() gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, { desc = 'git stage hunk' })
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git stage hunk' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git reset hunk' })
        map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git stage buffer' })
        map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git reset buffer' })
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git preview hunk' })
        map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git blame line' })
        map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git diff against index' })
        map('n', '<leader>hD', function() gitsigns.diffthis('@') end, { desc = 'git diff against last commit' })
        map('n', '<leader>ht', gitsigns.toggle_current_line_blame, { desc = 'toggle git blame line' })
      end,
    },
  },
  { 'esmuellert/codediff.nvim', cmd = 'CodeDiff', keys = { { '<leader>gf', '<cmd>CodeDiff history %<CR>', desc = 'File History' }, { '<leader>gd', '<cmd>CodeDiff<CR>', desc = 'Git Diff' } } },
  { 'piersolenski/import.nvim', cmd = 'Import', keys = { { '<leader>fi', function() require('import').pick() end, desc = 'Import' } }, dependencies = { 'folke/snacks.nvim' }, opts = { picker = 'snacks' } },
  { 'nvim-lua/plenary.nvim', lazy = true },
  {
    'mrdwarf7/lazyjui.nvim',
    cmd = 'LazyJui',
    keys = { { '<leader>gj', function() require('lazyjui').open() end, desc = 'Open jjui' } },
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local lazyjui = require('lazyjui.init')
      package.loaded['lazyjui'] = lazyjui
      lazyjui.setup({ border = { chars = { '', '', '', '', '', '', '', '' }, thickness = 0, winhl_str = '' }, cmd = { 'jjui' }, height = 0.8, width = 0.9, winblend = 0, use_default_keymaps = true })
      vim.keymap.set('n', '<leader>gj', lazyjui.open, { desc = 'Open jjui' })
    end,
  },
  {
    'obsidian-nvim/obsidian.nvim',
    ft = { 'markdown', 'quarto' },
    cmd = 'Obsidian',
    keys = {
      { '<leader>nd', '<cmd>Obsidian today<CR>', desc = 'Obsidian Create/Update Today Note' },
      { '<leader>nn', desc = 'Obsidian New Named Note' },
      { '<leader>nt', '<cmd>Obsidian tags<CR>', desc = 'Obsidian Search for tags' },
      { '<leader>nw', '<cmd>Obsidian workspace<CR>', desc = 'Obsidian Select workspace' },
      { '<leader>nf', '<cmd>Obsidian quick_switch<CR>', desc = 'Obsidian Quick Switch' },
      { '<leader>ns', '<cmd>Obsidian search<CR>', desc = 'Obsidian Search' },
    },
    dependencies = { 'folke/snacks.nvim', 'nvim-lua/plenary.nvim', 'saghen/blink.cmp' },
    config = function()
      require('obsidian').setup({ legacy_commands = false, note_id_func = require('obsidian.builtin').title_id, picker = { name = 'snacks.pick' }, completion = { min_chars = 1 }, ui = { enable = false }, workspaces = { { name = 'work', path = '~/vaults/work' }, { name = 'personal', path = '~/vaults/personal' } } })
      vim.keymap.set('n', '<leader>nn', function()
        local title = vim.fn.input('Note title: ')
        if title ~= nil and title ~= '' then vim.cmd('Obsidian new ' .. vim.fn.fnameescape(title)) end
      end, { desc = 'Obsidian New Named Note' })
    end,
  },
  {
    'sudo-tee/opencode.nvim',
    cmd = 'Opencode',
    keys = { { '<leader>ac', function() require('opencode.api').toggle() end, desc = 'Toggle opencode' }, { '<leader>ac', function() require('opencode.api').add_visual_selection() end, mode = 'x', desc = 'Add selection to opencode' } },
    dependencies = { 'MeanderingProgrammer/render-markdown.nvim', 'saghen/blink.cmp', 'folke/snacks.nvim' },
    opts = {
      preferred_picker = 'snacks',
      default_global_keymaps = false,
      keymap = {
        input_window = { ['<cr>'] = { 'submit_input_prompt', mode = { 'n', 'i' }, desc = 'Submit prompt' }, ['<tab>'] = { 'switch_mode', mode = { 'n', 'i' }, desc = 'Switch agent mode' }, ['q'] = { 'close', mode = { 'n' }, desc = 'Close opencode' }, ['<M-v>'] = false, ['<C-v>'] = { 'paste_image', mode = { 'i' }, desc = 'Paste image from clipboard' } },
        output_window = { ['<tab>'] = { 'switch_mode', mode = { 'n' }, desc = 'Switch agent mode' }, ['q'] = { 'close', mode = { 'n' }, desc = 'Close opencode' } },
      },
    },
  },
  {
    'gbprod/yanky.nvim',
    lazy = false,
    config = function()
      require('yanky').setup()
      vim.keymap.set({ 'n', 'x' }, 'p', '<Plug>(YankyPutAfter)')
      vim.keymap.set({ 'n', 'x' }, 'P', '<Plug>(YankyPutBefore)')
      vim.keymap.set({ 'n', 'x' }, 'gp', '<Plug>(YankyGPutAfter)')
      vim.keymap.set({ 'n', 'x' }, 'gP', '<Plug>(YankyGPutBefore)')
      vim.keymap.set('n', '<C-p>', '<Plug>(YankyPreviousEntry)')
      vim.keymap.set('n', '<C-n>', '<Plug>(YankyNextEntry)')
    end,
  },
}
