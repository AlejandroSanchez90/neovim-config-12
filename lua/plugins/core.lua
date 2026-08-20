return {
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('tokyonight').setup({
        style = 'night',
        plugins = {
          blink = true,
          cmp = true,
        },
        on_highlights = function(hl, colors)
          hl.LineNr = { fg = colors.dark5 }
          hl.LineNrAbove = { fg = colors.dark5 }
          hl.LineNrBelow = { fg = colors.dark5 }
        end,
      })
      vim.cmd.colorscheme('tokyonight-night')
    end,
  },
  { 'nvim-tree/nvim-web-devicons', lazy = true },
  { 'christoomey/vim-tmux-navigator', lazy = false },
}
