vim.pack.add({ "https://github.com/stevearc/oil.nvim" })
require('oil').setup({
	float = {
		padding = 10,
		border = "single",
	},

    prompt_save_on_select_new_entry = false,
    keymaps = {
      ['q'] = { 'actions.close', mode = 'n' },
      ['<Esc>'] = { 'actions.close', mode = 'n' },

      ['<C-s>'] = {},
      ['yp'] = {
        desc = 'Copy filepath to system clipboard',
        callback = function()
          require('oil.actions').copy_entry_path.callback()
          vim.fn.setreg('+', vim.fn.getreg(vim.v.register))
        end,
      },
    },
    skip_confirm_for_simple_edits = true,
    view_options = {
      show_hidden = true,
    },
  })
-- vim.keymap.set("n", "<leader>e", require("oil").toggle_float, { desc = "Toggle floating Oil buffer" })
