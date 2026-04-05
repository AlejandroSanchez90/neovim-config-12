vim.pack.add({
  'https://github.com/zbirenbaum/copilot.lua',
  { src = 'https://github.com/nvim-lua/plenary.nvim', version = 'master' },
  'https://github.com/CopilotC-Nvim/CopilotChat.nvim',
})

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name == 'CopilotChat.nvim' and ev.data.kind == 'install' then
      vim.system({ 'make', 'tiktoken' }, { cwd = ev.data.spec.path })
    end
  end,
})

require('copilot').setup({
  suggestion = {
    auto_trigger = true,
    keymap = { accept = '<Tab>' },
  },
})

vim.keymap.set('i', '<C-e>', function() require('copilot.suggestion').dismiss() end, { desc = 'Dismiss Copilot suggestion' })
vim.api.nvim_set_hl(0, 'CopilotSuggestion', { fg = '#808080', italic = true })

local chat = require('CopilotChat')
chat.setup({
  provider = 'copilot',
  mappings = {
    complete = { insert = '<C-t>' },
  },
  auto_follow_cursor = true,
  context = 'buffer',
  prompts = {
    Memo = {
      prompt = 'Add memoize to this code, if its a void use useCallback , if it returns a value useMemo, just reply with the update code nothing else',
      description = 'Add memoization to the code',
      mapping = '<leader>au',
      auto_follow_cursor = true,
    },
    XML = {
      prompt = 'Create an XML for this code, just reply with the XML nothing else',
      description = 'Create an XML schema for the code',
      mapping = '<leader>ax',
    },
  },
})

vim.keymap.set({ 'n', 'v' }, '<leader>ac', chat.toggle, { desc = 'copilot chat' })
vim.keymap.set({ 'n', 'v' }, '<leader>ar', '<cmd>CopilotChatReset<cr>', { desc = 'copilot reset' })
vim.keymap.set({ 'n', 'v' }, '<leader>af', '<cmd>CopilotChatFix<cr>', { desc = 'copilot fix' })
vim.keymap.set('n', '<leader>am', '<cmd>CopilotChatCommit<cr>', { desc = 'Copilot commit message' })
vim.keymap.set({ 'n', 'v' }, '<leader>ap', '<cmd>CopilotChatPrompts<cr>', { desc = 'Copilot Prompts' })
