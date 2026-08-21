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
      { '<leader>nn', desc = 'Obsidian New Named Note' },
      { '<leader>nt', '<cmd>Obsidian tags<CR>', desc = 'Obsidian Search for tags' },
      { '<leader>nw', '<cmd>Obsidian workspace<CR>', desc = 'Obsidian Select workspace' },
      { '<leader>nf', '<cmd>Obsidian quick_switch<CR>', desc = 'Obsidian Quick Switch' },
      { '<leader>ns', '<cmd>Obsidian search<CR>', desc = 'Obsidian Search' },
    },
    dependencies = { 'folke/snacks.nvim', 'nvim-lua/plenary.nvim', 'saghen/blink.cmp' },
    config = function()
      local vault = vim.env.OBSIDIAN_VAULT
      if not vault or vault == '' then
        error('Set OBSIDIAN_VAULT to the local path of your synced Obsidian vault.')
      end

      require('obsidian').setup({
        legacy_commands = false,
        note_id_func = require('obsidian.builtin').title_id,
        notes_subdir = nil,
        new_notes_location = 'notes_subdir',
        daily_notes = { enabled = false },
        picker = { name = 'snacks.pick' },
        completion = { min_chars = 1 },
        ui = { enable = false },
        workspaces = {
          { name = 'work', path = vim.fs.joinpath(vault, 'work'), strict = true },
          { name = 'personal', path = vim.fs.joinpath(vault, 'personal'), strict = true },
        },
      })
      vim.keymap.set('n', '<leader>nn', function()
        local title = vim.fn.input('Note title: ')
        if title ~= nil and title ~= '' then vim.cmd('Obsidian new ' .. vim.fn.fnameescape(title)) end
      end, { desc = 'Obsidian New Named Note' })
    end,
  },
  {
    'folke/sidekick.nvim',
    version = 'v2.*',
    cmd = 'Sidekick',
    keys = {
      {
        '<leader>ac',
        function()
          local Session = require('sidekick.cli.session')
          local State = require('sidekick.cli.state')
          local state = State.get({ name = 'opencode', cwd = true, external = false })[1]

          if not state then
            state = State.get_state(Session.new({ tool = 'opencode', cwd = Session.cwd() }))
          end

          local attached
          state, attached = State.attach(state)
          if state.terminal then
            if not attached then state.terminal:toggle() end
            if state.terminal:is_open() then state.terminal:focus() end
          end
        end,
        desc = 'Toggle OpenCode',
      },
      { '<leader>ac', function() require('sidekick.cli').send({ name = 'opencode', msg = '{selection}' }) end, mode = 'x', desc = 'Send selection to OpenCode' },
    },
    opts = {
      nes = { enabled = false },
      cli = {
        win = { keys = { files = false } },
        mux = { enabled = false },
        picker = 'snacks',
        tools = { opencode = {} },
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
