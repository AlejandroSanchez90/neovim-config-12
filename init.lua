vim.pack.add({
	"https://github.com/folke/tokyonight.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/christoomey/vim-tmux-navigator",
})

require('tokyonight').setup({
  style = 'night',
  plugins = {
    blink = true,
    cmp = true,
  },
  on_highlights = function(hl, c)
    hl.LineNr = { fg = c.dark5 }
    hl.LineNrAbove = { fg = c.dark5 }
    hl.LineNrBelow = { fg = c.dark5 }
  end,
})

vim.cmd.colorscheme("tokyonight-night")

require("lsp-setup")
require("autocmd")
require("keymaps")
require("options")
