vim.pack.add({ "https://github.com/numToStr/Comment.nvim",
  'https://github.com/JoosepAlviste/nvim-ts-context-commentstring', })

local comment = require 'Comment'

local ts_context_commentstring = require 'ts_context_commentstring.integrations.comment_nvim'

comment.setup {
  pre_hook = ts_context_commentstring.create_pre_hook(),
}
