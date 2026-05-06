vim.pack.add({ "https://github.com/folke/snacks.nvim" })

require("snacks").setup({
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
    sources = {
      files = { hidden = true },
      grep = { hidden = true },
      git_grep_hunks = {
        supports_live = false,
        format = function(item, picker)
          local file_format = Snacks.picker.format.file(item, picker)
          vim.api.nvim_set_hl(0, 'SnacksPickerGitGrepLineNew', { link = 'Added' })
          vim.api.nvim_set_hl(0, 'SnacksPickerGitGrepLineOld', { link = 'Removed' })
          if item.sign == '+' then
            file_format[#file_format - 1][2] = 'SnacksPickerGitGrepLineNew'
          else
            file_format[#file_format - 1][2] = 'SnacksPickerGitGrepLineOld'
          end
          return file_format
        end,
        finder = function(f_opts, ctx)
          local hcount = 0
          local header = {
            file = '',
            old = { start = 0, count = 0 },
            new = { start = 0, count = 0 },
          }
          local sign_count = 0
          return require('snacks.picker.source.proc').proc(
            vim.tbl_extend('force', f_opts or {}, {
              cmd = 'git',
              args = { 'diff', 'HEAD', '--unified=0' },
              transform = function(item) ---@param item snacks.picker.finder.Item
                local line = item.text
                -- [[Header]]
                if line:match '^diff' then
                  hcount = 3
                elseif hcount > 0 then
                  if hcount == 1 then
                    header.file = line:sub(7)
                  end
                  hcount = hcount - 1
                elseif line:match '^@@' then
                  local parts = vim.split(line:match '@@ ([^@]+) @@', ' ')
                  local old_start, old_count = parts[1]:match '-(%d+),?(%d*)'
                  local new_start, new_count = parts[2]:match '+(%d+),?(%d*)'
                  header.old.start, header.old.count = tonumber(old_start), tonumber(old_count) or 1
                  header.new.start, header.new.count = tonumber(new_start), tonumber(new_count) or 1
                  sign_count = 0
                  -- [[Body]]
                elseif not line:match '^[+-]' then
                  sign_count = 0
                elseif line:match '^[+-]%s*$' then
                  sign_count = sign_count + 1
                else
                  item.sign = line:sub(1, 1)
                  item.file = header.file
                  item.line = line:sub(2)
                  if item.sign == '+' then
                    item.pos = { header.new.start + sign_count, 0 }
                    sign_count = sign_count + 1
                  else
                    return false
                  end
                  return true
                end
                return false
              end,
            }),
            ctx
          )
        end,
      },
      smart = {
        multi = { 'buffers', 'recent', 'files' },
        filter = { cwd = true },
      },
    },
  }
})


vim.keymap.set('n', '<leader>fu', function()
  Snacks.picker.undo {
    on_show = function()
      vim.cmd.stopinsert()
    end,
  }
end, { desc = 'LSP Workspace Symbols' })

vim.keymap.set('n', '<leader>bo', function()
  Snacks.bufdelete.other()
end, { desc = 'Close other buffers' })

vim.keymap.set('n', '<leader>bd', function()
  Snacks.bufdelete.delete()
end, { desc = 'Close other buffers' })

vim.keymap.set('n', '<leader>fdw', function()
  Snacks.picker.diagnostics {
    on_show = function()
      vim.cmd.stopinsert()
    end,
  }
end, { desc = 'Diagnostics' })

vim.keymap.set('n', '<leader>fh', function()
  Snacks.picker.help()
end, { desc = 'Help' })

vim.keymap.set('n', '<leader>fk', function()
  Snacks.picker.keymaps()
end, { desc = 'Help' })

vim.keymap.set('n', '<leader>fdd', function()
  Snacks.picker.diagnostics_buffer {
    on_show = function()
      vim.cmd.stopinsert()
    end,
  }
end, { desc = 'Buffer Diagnostics' })

vim.keymap.set('n', '<leader>ff', function()
  Snacks.picker.files()
end, { desc = 'Find Files' })

vim.keymap.set('n', '<leader>fr', function()
  Snacks.picker.resume()
end, { desc = 'Resume' })

vim.keymap.set('n', '<leader>fb', function()
  Snacks.picker.buffers {
    sort_lastused = true,
    focus = 'list',
    win = {
      preview = {
        wo = { number = false, relativenumber = false },
      },
    },
  }
end, { desc = 'Buffers' })

vim.keymap.set('n', '<leader>fg', function()
  Snacks.picker.git_grep_hunks()
end, { desc = 'Search git diff' })

vim.keymap.set('n', '<leader>fs', function()
  Snacks.picker.grep()
end, { desc = 'Grep' })

vim.keymap.set({ 'n', 'x' }, '<leader>fc', function()
  Snacks.picker.grep_word()
end, { desc = 'Visual selection or word' })

vim.keymap.set('n', 'gr', function()
  Snacks.picker.lsp_references {
    on_show = function()
      vim.cmd.stopinsert()
    end,
  }
end, { nowait = true, desc = 'References' })

vim.keymap.set('n', 'gd', function()
  Snacks.picker.lsp_definitions {
    on_show = function()
      vim.cmd.stopinsert()
    end,
  }
end, { desc = 'Goto Definition' })

vim.keymap.set('n', 'gt', function()
  Snacks.picker.lsp_type_definitions {
    on_show = function()
      vim.cmd.stopinsert()
    end,
  }
end, { desc = 'Goto Type Definition' })

vim.keymap.set('n', 'gi', function()
  Snacks.picker.lsp_implementations {
    on_show = function()
      vim.cmd.stopinsert()
    end,
  }
end, { desc = 'Goto Implementation' })

vim.keymap.set('n', 'gy', function()
  Snacks.picker.lsp_type_definitions {
    on_show = function()
      vim.cmd.stopinsert()
    end,
  }
end, { desc = 'Goto T[y]pe Definition' })

vim.keymap.set('n', '<leader>ss', function()
  Snacks.picker.lsp_symbols {
    on_show = function()
      vim.cmd.stopinsert()
    end,
  }
end, { desc = 'LSP Symbols' })

vim.keymap.set('n', '<leader>sS', function()
  Snacks.picker.lsp_workspace_symbols {
    on_show = function()
      vim.cmd.stopinsert()
    end,
  }
end, { desc = 'LSP Workspace Symbols' })
