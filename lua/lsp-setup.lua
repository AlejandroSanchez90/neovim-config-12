vim.diagnostic.config({
	virtual_text = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "single",
		source = true,
	},
})

vim.lsp.enable({
	"astro",
	"buf_ls",
	"emmet_language_server",
	"gopls",
	"lua_ls",
	"rust_analyzer",
	"sql",
	"tailwindcss",
	"vtsls",
	"clangd",
	-- 'tsgo',
})
