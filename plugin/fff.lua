vim.pack.add({ 'https://github.com/dmtrKovalenko/fff.nvim' })

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name == 'fff.nvim' and (ev.data.kind == 'install' or ev.data.kind == 'update') then
      require('fff.download').download_or_build_binary()
    end
  end,
})

-- plugin/fff.lua (auto-sourced above) defers binary loading to UIEnter.
-- Download synchronously here so the binary is ready before UIEnter fires.
local download = require('fff.download')
if not vim.uv.fs_stat(download.get_binary_path()) then
  download.download_or_build_binary()
end

require('fff').setup({
  debug = {
    enabled = true,
    show_scores = true,
  },
  preview = {
    show_file_info = true,
  },
  git = {
    status_text_color = true,
  },
})

vim.keymap.set('n', '<leader><space>', function()
  require('fff').find_files()
end, { desc = 'FFFind files' })
