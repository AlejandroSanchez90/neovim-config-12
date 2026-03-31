vim.pack.add({
	"https://github.com/folke/tokyonight.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
})
vim.cmd.colorscheme("tokyonight")

require("lsp-setup")
