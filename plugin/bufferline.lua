vim.pack.add({ 'https://github.com/akinsho/bufferline.nvim' })

require('bufferline').setup({
  options = {
    diagnostics = 'nvim_lsp',
    show_buffer_close_icons = false,
    show_close_icon = false,
  },
})
