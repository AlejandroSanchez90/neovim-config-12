vim.pack.add({
  "https://github.com/rafamadriz/friendly-snippets",
{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.x"), },
})

require("blink.cmp").setup({
   completion = {
      documentation = {
         auto_show = true,
         auto_show_delay_ms = 500,
      },
   },
})

