vim.pack.add({
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/folke/noice.nvim',
})

require('noice').setup({
  routes = {
    {
      filter = { event = 'notify', find = 'No information available' },
      opts = { skip = true },
    },
  },
  lsp = {
    progress = { enabled = false },
    signature = {
      enabled = false,
      auto_open = { enabled = false, throttle = 2000, trigger = true },
    },
    override = {
      ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
      ['vim.lsp.util.stylize_markdown'] = true,
      ['cmp.entry.get_documentation'] = true,
    },
  },
  presets = {
    bottom_search = true,
    command_palette = true,
    long_message_to_split = true,
    inc_rename = false,
    lsp_doc_border = true,
  },
})
