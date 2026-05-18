vim.api.nvim_create_user_command('VimPackUpdate', function()
  vim.pack.update(nil, { offline = true })
end, { desc = 'Update vim.pack plugins offline' })
