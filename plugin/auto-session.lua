vim.pack.add({ 'https://github.com/rmagatti/auto-session' })

require('auto-session').setup({
  suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
  use_git_branch = true,
})
