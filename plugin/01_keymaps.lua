local nmap_leader = function(suffix, rhs, desc)
	vim.keymap.set("n", "<Leader>" .. suffix, rhs, { desc = desc })
end

local xmap_leader = function(suffix, rhs, desc)
	vim.keymap.set("x", "<Leader>" .. suffix, rhs, { desc = desc })
end

local imap_leader = function(suffix, rhs, desc)
	vim.keymap.set("i", "<Leader>" .. suffix, rhs, { desc = desc })
end

-- Better Esc
vim.keymap.set("i", "kj", "<Esc>", { desc = "ESC remap" })

-- Oil Keymaps

local explore_at_file = "<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>"
nmap_leader("e", '<Cmd>lua MiniFiles.open()<CR>', "Open MiniFiles")
