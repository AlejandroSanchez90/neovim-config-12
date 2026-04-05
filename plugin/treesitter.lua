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
  "https://github.com/catgoose/nvim-colorizer.lua",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  'https://github.com/windwp/nvim-ts-autotag',
})

require("colorizer").setup({
  "*",
  tailwind = { enable = true },
})


require('nvim-ts-autotag').setup {
  opts = {
    enable_close = true,
    enable_rename = true,
    enable_close_on_slash = false,
  },
}

local nts = require("nvim-treesitter")
nts.setup({
  install_dir = vim.fn.stdpath("data") .. "/site",
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
    local ft = vim.bo[args.buf].filetype
    local lang = vim.treesitter.language.get_lang(ft)
    if not lang then return end

    if not vim.treesitter.language.add(lang) then
      local available = vim.g.ts_available or nts.get_available()
      if not vim.g.ts_available then vim.g.ts_available = available end
      if vim.tbl_contains(available, lang) then
        nts.install({ lang })
      end
    end

    if vim.treesitter.language.add(lang) then
      vim.treesitter.start(args.buf, lang)
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.wo[0][0].foldmethod = "expr"
    end
  end,
})
