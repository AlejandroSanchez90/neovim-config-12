vim.pack.add({
	"https://github.com/folke/tokyonight.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/christoomey/vim-tmux-navigator",
})

vim.cmd.colorscheme("tokyonight-night")

require("lsp-setup")
require("autocmd")
require("keymaps")
require("options")
