--  This is to update treesitter on update
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "nvim-treesitter" and kind == "update" then
			if not ev.data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			vim.cmd("TSUpdate")
		end
	end,
})

vim.pack.add({
	"https://github.com/norcalli/nvim-colorizer.lua",
	"https://github.com/nvim-treesitter/nvim-treesitter",
})

require("colorizer").setup({
	"*",
	tailwind = { enable = true },
})
local nts = require("nvim-treesitter")
nts.setup({
	install_dir = vim.fn.stdpath("data") .. "/site",
	highlight = {
		enable = true,
		disable = function(_, bufnr)
			return ts_disable(_, bufnr)
		end,
	},
	indent = { enable = true },
})

local parsers = {
	"json5",
	"javascript",
	"typescript",
	"tsx",
	"yaml",
	"html",
	"css",
	"diff",
	-- 'prisma',
	"markdown",
	"markdown_inline",
	"bash",
	"lua",
	"vim",
	"dockerfile",
	"gitignore",
	"query",
	"vimdoc",
}

nts.install(parsers):wait(300000)

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		if pcall(vim.treesitter.start, args.buf) then
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
})
