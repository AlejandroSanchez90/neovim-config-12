vim.pack.add({ 'https://github.com/nvim-lualine/lualine.nvim' })

local arrow_status = require('arrow.statusline')

local function isRecording()
  local reg = vim.fn.reg_recording()
  return reg ~= '' and ('Macro: ' .. reg) or ''
end

require('lualine').setup({
  options = {
    theme = 'tokyonight',
  },
  sections = {
    lualine_c = {
      {
        function() return arrow_status.text_for_statusline_with_icons() end,
        cond = function() return arrow_status.is_on_arrow_file() ~= nil end,
        color = { fg = '#51cf66', gui = 'bold' },
      },
      { 'filename', path = 1, file_status = true, color = { gui = 'bold' } },
    },
    lualine_x = {
      {
        isRecording,
        cond = function() return vim.fn.reg_recording() ~= '' end,
        color = { fg = '#ff6666' },
      },
    },
  },
  inactive_sections = {
    lualine_c = { { 'filename', path = 0, file_status = true } },
  },
})
