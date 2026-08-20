return {
  {
    'nvim-mini/mini.nvim',
    lazy = false,
    config = function()
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
        window = { delay = 250 },
        triggers = {
          { mode = 'n', keys = '<leader>' },
          { mode = 'x', keys = '<leader>' },
          { mode = 'n', keys = 'g' },
          { mode = 'n', keys = 'z' },
          { mode = 'n', keys = '<C-w>' },
        },
        clues = {
          { mode = { 'n', 'x' }, keys = '<leader>a', desc = '+AI' },
          { mode = { 'n', 'x' }, keys = '<leader>b', desc = '+Buffers' },
          { mode = { 'n', 'x' }, keys = '<leader>f', desc = '+Find' },
          { mode = { 'n', 'x' }, keys = '<leader>g', desc = '+Git' },
          { mode = { 'n', 'x' }, keys = '<leader>m', desc = '+Debug' },
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
          close = 'q',
          go_in = 'l',
          go_in_plus = '<CR>',
          go_out = 'h',
          go_out_plus = 'H',
          mark_goto = "'",
          mark_set = 'm',
          reset = '<BS>',
          reveal_cwd = '_',
          show_help = 'g?',
          synchronize = '<C-s>',
          trim_left = '<',
          trim_right = '>',
        },
      })

      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesBufferCreate',
        callback = function(args)
          vim.keymap.set('n', 'yp', function()
            local path = (MiniFiles.get_fs_entry() or {}).path
            if path == nil then
              return vim.notify('Cursor is not on valid entry')
            end
            vim.fn.setreg('+', path)
            vim.notify('Yanked path: ' .. path)
          end, { buffer = args.data.buf_id, desc = 'Yank path' })
        end,
      })

      vim.keymap.set('n', '<leader>e', '<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>',
        { desc = 'Toggle files explorer' })
      require('mini.icons').setup({})
    end,
  },
  {
    'folke/trouble.nvim',
    lazy = false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = { focus = true },
    keys = {
      { '<leader>xq', desc = 'Quickfix (Trouble)' },
      { '<leader>xl', desc = 'Location List (Trouble)' },
      { '<leader>xx', desc = 'Buffer Diagnostics (Trouble)' },
      { '<leader>xX', desc = 'Diagnostics (Trouble)' },
    },
    config = function(_, opts)
      require('trouble').setup(opts)
      vim.keymap.set('n', '<leader>xq', '<cmd>Trouble qflist toggle<CR>', { desc = 'Quickfix (Trouble)' })
      vim.keymap.set('n', '<leader>xl', '<cmd>Trouble loclist toggle<CR>', { desc = 'Location List (Trouble)' })
      vim.keymap.set('n', '<leader>xx', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>',
        { desc = 'Buffer Diagnostics (Trouble)' })
      vim.keymap.set('n', '<leader>xX', '<cmd>Trouble diagnostics toggle<CR>', { desc = 'Diagnostics (Trouble)' })
    end,
  },
  {
    'folke/snacks.nvim',
    lazy = false,
    dependencies = { 'folke/trouble.nvim', 'nvim-mini/mini.nvim' },
    config = function()
      require('snacks').setup({
        git = { enabled = true },
        bigfile = { enabled = true },
        rename = { enabled = true },
        bufdelete = { enabled = true },
        indent = { enabled = true, animate = { enabled = false }, chunk = { enabled = true } },
        input = { enabled = true },
        notifier = {},
        picker = {
          enabled = true,
          ui_select = true,
          actions = require('trouble.sources.snacks').actions,
          win = {
            input = { keys = { ['<c-q>'] = { 'trouble_open', mode = { 'n', 'i' } }, ['<c-t>'] = { 'trouble_open', mode = { 'n', 'i' } } } },
            list = { keys = { ['<c-q>'] = { 'trouble_open', mode = { 'n', 'i' } } } },
          },
          sources = {
            files = { hidden = true },
            grep = { hidden = true },
            git_grep_hunks = {
              supports_live = false,
              format = function(item, picker)
                local file_format = Snacks.picker.format.file(item, picker)
                vim.api.nvim_set_hl(0, 'SnacksPickerGitGrepLineNew', { link = 'Added' })
                vim.api.nvim_set_hl(0, 'SnacksPickerGitGrepLineOld', { link = 'Removed' })
                file_format[#file_format - 1][2] = item.sign == '+' and 'SnacksPickerGitGrepLineNew' or
                'SnacksPickerGitGrepLineOld'
                return file_format
              end,
              finder = function(f_opts, ctx)
                local hcount, sign_count = 0, 0
                local header = { file = '', old = { start = 0, count = 0 }, new = { start = 0, count = 0 } }
                return require('snacks.picker.source.proc').proc(vim.tbl_extend('force', f_opts or {}, {
                  cmd = 'git',
                  args = { 'diff', 'HEAD', '--unified=0' },
                  transform = function(item)
                    local line = item.text
                    if line:match('^diff') then
                      hcount = 3
                    elseif hcount > 0 then
                      if hcount == 1 then header.file = line:sub(7) end
                      hcount = hcount - 1
                    elseif line:match('^@@') then
                      local parts = vim.split(line:match('@@ ([^@]+) @@'), ' ')
                      local old_start, old_count = parts[1]:match('-(%d+),?(%d*)')
                      local new_start, new_count = parts[2]:match('%+(%d+),?(%d*)')
                      header.old.start, header.old.count = tonumber(old_start), tonumber(old_count) or 1
                      header.new.start, header.new.count = tonumber(new_start), tonumber(new_count) or 1
                      sign_count = 0
                    elseif not line:match('^[+-]') then
                      sign_count = 0
                    elseif line:match('^[+-]%s*$') then
                      sign_count = sign_count + 1
                    else
                      item.sign, item.file, item.line = line:sub(1, 1), header.file, line:sub(2)
                      if item.sign ~= '+' then return false end
                      item.pos = { header.new.start + sign_count, 0 }
                      sign_count = sign_count + 1
                      return true
                    end
                    return false
                  end,
                }), ctx)
              end,
            },
            smart = { multi = { 'buffers', 'recent', 'files' }, filter = { cwd = true } },
          },
        },
      })
      local picker = Snacks.picker
      local stop_insert = function() vim.cmd.stopinsert() end
      vim.keymap.set('n', '<leader>fu', function() picker.undo({ on_show = stop_insert }) end,
        { desc = 'LSP Workspace Symbols' })
      vim.keymap.set('n', '<leader>bo', Snacks.bufdelete.other, { desc = 'Close other buffers' })
      vim.keymap.set('n', '<leader>bd', Snacks.bufdelete.delete, { desc = 'Close other buffers' })
      vim.keymap.set('n', '<leader>fdw', '<cmd>Trouble diagnostics toggle<CR>', { desc = 'Diagnostics (Trouble)' })
      vim.keymap.set('n', '<leader>fh', picker.help, { desc = 'Help' })
      vim.keymap.set('n', '<leader>fk', picker.keymaps, { desc = 'Help' })
      vim.keymap.set('n', '<leader>fdd', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>',
        { desc = 'Buffer Diagnostics (Trouble)' })
      vim.keymap.set('n', '<leader>ff', picker.files, { desc = 'Find Files' })
      vim.keymap.set('n', '<leader>fr', picker.resume, { desc = 'Resume' })
      vim.keymap.set('n', '<leader>fb',
        function() picker.buffers({ sort_lastused = true, focus = 'list', win = { preview = { wo = { number = false, relativenumber = false } } } }) end,
        { desc = 'Buffers' })
      vim.keymap.set('n', '<leader>fg', picker.git_grep_hunks, { desc = 'Search git diff' })
      vim.keymap.set('n', '<leader>fs', picker.grep, { desc = 'Grep' })
      vim.keymap.set({ 'n', 'x' }, '<leader>fc', picker.grep_word, { desc = 'Visual selection or word' })
      vim.keymap.set('n', 'gr', function() picker.lsp_references({ on_show = stop_insert }) end,
        { nowait = true, desc = 'References' })
      vim.keymap.set('n', 'gd', function() picker.lsp_definitions({ on_show = stop_insert }) end,
        { desc = 'Goto Definition' })
      vim.keymap.set('n', 'gt', function() picker.lsp_type_definitions({ on_show = stop_insert }) end,
        { desc = 'Goto Type Definition' })
      vim.keymap.set('n', 'gi', function() picker.lsp_implementations({ on_show = stop_insert }) end,
        { desc = 'Goto Implementation' })
      vim.keymap.set('n', 'gy', function() picker.lsp_type_definitions({ on_show = stop_insert }) end,
        { desc = 'Goto T[y]pe Definition' })
      vim.keymap.set('n', '<leader>ss', function() picker.lsp_symbols({ on_show = stop_insert }) end,
        { desc = 'LSP Symbols' })
      vim.keymap.set('n', '<leader>sS', function() picker.lsp_workspace_symbols({ on_show = stop_insert }) end,
        { desc = 'LSP Workspace Symbols' })
    end,
  },
  {
    'otavioschwanck/arrow.nvim',
    lazy = false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('arrow').setup({ show_icons = true, leader_key = "'", buffer_leader_key = 'm', separate_by_branch = true, per_buffer_config = { lines = 5 } })
      local persist = require('arrow.persist')
      vim.keymap.set('n', 'H', persist.previous)
      vim.keymap.set('n', 'L', persist.next)
      vim.keymap.set('n', 'M', persist.toggle)
      for i = 1, 5 do vim.keymap.set('n', '<leader>' .. i, function() persist.go_to(i) end,
          { desc = 'Go to Arrow file ' .. i }) end
    end,
  },
  {
    'akinsho/bufferline.nvim',
    lazy = false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = { options = { diagnostics = 'nvim_lsp', show_buffer_close_icons = false, show_close_icon = false, truncate_names = false, max_name_length = 80, tab_size = 24 } },
  },
  {
    'nvim-lualine/lualine.nvim',
    lazy = false,
    dependencies = { 'otavioschwanck/arrow.nvim', 'nvim-tree/nvim-web-devicons' },
    config = function()
      local arrow_status = require('arrow.statusline')
      local lazy_status = require('lazy.status')
      require('lualine').setup({
        options = { theme = 'tokyonight' },
        sections = {
          lualine_c = {
            { function() return arrow_status.text_for_statusline_with_icons() end, cond = function() return arrow_status
              .is_on_arrow_file() ~= nil end,                                                                                                           color = { fg = '#51cf66', gui = 'bold' } },
            { 'filename',                                                          path = 1,                                                            file_status = true,                      color = { gui = 'bold' } },
          },
          lualine_x = {
            { function()
              local reg = vim.fn.reg_recording(); return reg ~= '' and ('Macro: ' .. reg) or ''
            end,                                                                                                cond = function() return
              vim.fn.reg_recording() ~= '' end,                                                                                                                            color = { fg = '#ff6666' } },
            { lazy_status.updates,                                                                              cond = lazy_status.has_updates,                            color = { fg = '#ff9e64' } },
          },
        },
        inactive_sections = { lualine_c = { { 'filename', path = 0, file_status = true } } },
      })
    end,
  },
  { 'rmagatti/auto-session', lazy = false, opts = { suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' }, use_git_branch = true } },
  {
    'stevearc/oil.nvim',
    lazy = false,
    dependencies = { 'nvim-mini/mini.nvim' },
    opts = {
      float = { padding = 10, border = 'single' },
      prompt_save_on_select_new_entry = false,
      keymaps = {
        ['q'] = { 'actions.close', mode = 'n' },
        ['<Esc>'] = { 'actions.close', mode = 'n' },
        ['<C-s>'] = {},
        ['yp'] = { desc = 'Copy filepath to system clipboard', callback = function()
          require('oil.actions').copy_entry_path.callback(); vim.fn.setreg('+', vim.fn.getreg(vim.v.register))
        end },
      },
      skip_confirm_for_simple_edits = true,
      view_options = { show_hidden = true },
    },
  },
  {
    url = 'https://codeberg.org/andyg/leap.nvim',
    name = 'leap.nvim',

    lazy = false,
    config = function() vim.keymap.set({ 'n', 'x', 'o' }, '<CR>', '<Plug>(leap)') end,
  },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = { 'MunifTanjim/nui.nvim', 'folke/snacks.nvim' },
    opts = {
      routes = { { filter = { event = 'notify', find = 'No information available' }, opts = { skip = true } } },
      lsp = { progress = { enabled = false }, signature = { enabled = false, auto_open = { enabled = false, throttle = 2000, trigger = true } }, override = { ['vim.lsp.util.convert_input_to_markdown_lines'] = true, ['vim.lsp.util.stylize_markdown'] = true, ['cmp.entry.get_documentation'] = true } },
      presets = { bottom_search = true, command_palette = true, long_message_to_split = true, inc_rename = false, lsp_doc_border = true },
    },
  },
  {
    'akinsho/toggleterm.nvim',
    cmd = { 'ToggleTerm', 'ToggleTermToggleAll', 'TermExec', 'TermNew', 'TermSelect', 'ToggleTermSendVisualLines', 'ToggleTermSendVisualSelection', 'ToggleTermSendCurrentLine', 'ToggleTermSetName' },
    keys = { { '<leader>tt' }, { '<leader>tf' }, { '<leader>th' }, { '<leader>tv' }, { '<leader>t1' }, { '<leader>t2' } },
    config = function()
      require('toggleterm').setup({ direction = 'float' })
      vim.keymap.set('n', '<leader>tt', '<cmd>ToggleTerm<CR>', { desc = 'Toggle terminal' })
      vim.keymap.set('n', '<leader>tf', '<cmd>ToggleTerm direction=float<CR>', { desc = 'Toggle float terminal' })
      vim.keymap.set('n', '<leader>th', '<cmd>ToggleTerm direction=horizontal<CR>',
        { desc = 'Toggle horizontal terminal' })
      vim.keymap.set('n', '<leader>tv', '<cmd>ToggleTerm direction=vertical<CR>', { desc = 'Toggle vertical terminal' })
      vim.keymap.set('n', '<leader>t1', '<cmd>1ToggleTerm direction=horizontal<CR>',
        { desc = 'Toggle terminal 1 (horizontal)' })
      vim.keymap.set('n', '<leader>t2', '<cmd>2ToggleTerm direction=horizontal<CR>',
        { desc = 'Toggle terminal 2 (horizontal)' })
      vim.api.nvim_create_autocmd('TermOpen', {
        pattern = 'term://*toggleterm#*',
        callback = function()
          local opts = { buffer = 0 }
          vim.keymap.set('t', 'kj', [[<C-\><C-n>]], opts)
          vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], opts)
          vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
          vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
          vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
          vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
        end
      })
    end,
  },
}
