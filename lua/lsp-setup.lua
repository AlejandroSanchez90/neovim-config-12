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
	"emmet_language_server",
	"lua_ls",
	"tailwindcss",
	"vtsls",
	"clangd",
})
