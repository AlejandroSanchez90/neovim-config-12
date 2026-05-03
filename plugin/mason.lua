vim.pack.add({
	"https://github.com/mason-org/mason.nvim",
})

require("mason").setup()

local ensure_installed = {
	"tailwindcss-language-server",
	"vtsls",
	"emmet-language-server",
	"eslint-lsp",
	"prettier",
	"clangd",
	"clang-format",
}

vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = function()
		local registry = require("mason-registry")
		registry.refresh(function()
			for _, name in ipairs(ensure_installed) do
				local pkg = registry.get_package(name)
				if not pkg:is_installed() then
					pkg:install()
				end
			end
		end)
	end,
})
