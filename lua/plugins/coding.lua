return {
  {
    'mason-org/mason.nvim',
    lazy = false,
    config = function()
      require('mason').setup()
      local ensure_installed = {
        'tailwindcss-language-server', 'vtsls', 'emmet-language-server', 'eslint-lsp',
        'prettier', 'clangd', 'lua-language-server', 'clang-format',
      }
      vim.api.nvim_create_autocmd('VimEnter', {
        once = true,
        callback = function()
          local registry = require('mason-registry')
          registry.refresh(function()
            for _, name in ipairs(ensure_installed) do
              local package = registry.get_package(name)
              if not package:is_installed() then package:install() end
            end
          end)
        end,
      })
    end,
  },
  {
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
    build = 'make install_jsregexp',
    dependencies = { 'rafamadriz/friendly-snippets' },
    config = function()
      require('luasnip.loaders.from_vscode').lazy_load()
      require('luasnip.loaders.from_vscode').lazy_load({ paths = { vim.fn.stdpath('config') .. '/snippets' } })
    end,
  },
  {
    'saghen/blink.cmp',
    lazy = false,
    version = '1.*',
    dependencies = { 'L3MON4D3/LuaSnip' },
    config = function()
      require('blink.cmp').setup({
        completion = {
          accept = { resolve_timeout_ms = 400, auto_brackets = { enabled = false } },
          menu = { border = 'single', draw = { gap = 2, columns = { { 'kind_icon', 'label', 'label_description', gap = 1 }, { 'kind', 'source_name', gap = 1 } } } },
          documentation = { auto_show = true, auto_show_delay_ms = 200 },
        },
        signature = { enabled = true },
        keymap = { preset = 'default', ['<C-y>'] = { function(cmp) return cmp.select_and_accept({ force = true }) end, 'fallback' } },
        appearance = { use_nvim_cmp_as_default = true, nerd_font_variant = 'mono' },
        snippets = { preset = 'luasnip' },
        sources = { default = { 'lsp', 'path', 'snippets', 'buffer' }, providers = {} },
      })
      vim.lsp.config('*', { capabilities = require('blink.cmp').get_lsp_capabilities() })
    end,
  },
  {
    'neovim/nvim-lspconfig',
    lazy = false,
    dependencies = { 'mason-org/mason.nvim', 'saghen/blink.cmp' },
    config = function() require('lsp-setup')() end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      local treesitter = require('nvim-treesitter')
      treesitter.setup({ install_dir = vim.fn.stdpath('data') .. '/site', indent = { enable = true } })
      local parsers = {
        'json5', 'javascript', 'typescript', 'tsx', 'yaml', 'html', 'css', 'diff', 'markdown',
        'markdown_inline', 'bash', 'lua', 'vim', 'dockerfile', 'gitignore', 'query', 'vimdoc',
      }
      treesitter.install(parsers):wait(300000)
      vim.treesitter.language.register('markdown', 'opencode_output')
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local filetype = vim.bo[args.buf].filetype
          local language = vim.treesitter.language.get_lang(filetype)
          if not language then return end
          if not vim.treesitter.language.add(language) then
            local available = vim.g.ts_available or treesitter.get_available()
            if not vim.g.ts_available then vim.g.ts_available = available end
            if vim.tbl_contains(available, language) then treesitter.install({ language }) end
          end
          if vim.treesitter.language.add(language) then
            vim.treesitter.start(args.buf, language)
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            vim.wo[0][0].foldmethod = 'expr'
          end
        end,
      })
    end,
  },
  {
    'windwp/nvim-ts-autotag',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = { opts = { enable_close = true, enable_rename = true, enable_close_on_slash = false } },
  },
  {
    'catgoose/nvim-colorizer.lua',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function() require('colorizer').setup({ '*', tailwind = { enable = true } }) end,
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {},
  },
  {
    'numToStr/Comment.nvim',
    event = 'VeryLazy',
    dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
    config = function()
      require('Comment').setup({
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      })
    end,
  },
  {
    'stevearc/conform.nvim',
    event = 'BufWritePre',
    cmd = 'ConformInfo',
    opts = {
      format_on_save = { lsp_format = 'fallback' },
      formatters_by_ft = {
        javascript = { 'prettier' }, javascriptreact = { 'prettier' }, typescript = { 'prettier' },
        typescriptreact = { 'prettier' }, css = { 'prettier' }, scss = { 'prettier' }, html = { 'prettier' },
        json = { 'prettier' }, yaml = { 'prettier' }, markdown = { 'prettier' }, graphql = { 'prettier' },
        lua = { 'stylua' }, go = { 'gofmt' }, sql = { 'sqruff' }, proto = { 'buf-format' }, c = { 'clang_format' },
        cpp = { 'clang_format' }, objc = { 'clang_format' }, objcpp = { 'clang_format' },
      },
    },
  },
  {
    'mfussenegger/nvim-lint',
    event = { 'BufEnter', 'BufWritePost', 'InsertLeave' },
    config = function()
      local lint = require('lint')
      lint.linters_by_ft = { sql = { 'sqruff' }, javascript = { 'eslint_d' }, javascriptreact = { 'eslint_d' }, typescript = { 'eslint_d' }, typescriptreact = { 'eslint_d' } }
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = vim.api.nvim_create_augroup('nvim-lint', { clear = true }),
        callback = function()
          if vim.opt_local.modifiable:get() then lint.try_lint(nil, { ignore_errors = true }) end
        end,
      })
    end,
  },
  {
    'zbirenbaum/copilot.lua',
    event = 'InsertEnter',
    cmd = 'Copilot',
    config = function()
      require('copilot').setup({
        auth_provider_url = 'https://eog-resources-inc.ghe.com/',
        suggestion = { auto_trigger = true, keymap = { accept = '<Tab>' } },
      })
      vim.keymap.set('i', '<C-e>', function() require('copilot.suggestion').dismiss() end, { desc = 'Dismiss Copilot suggestion' })
      vim.api.nvim_set_hl(0, 'CopilotSuggestion', { fg = '#808080', italic = true })
    end,
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    cmd = { 'CopilotChat', 'CopilotChatOpen', 'CopilotChatClose', 'CopilotChatToggle', 'CopilotChatStop', 'CopilotChatReset', 'CopilotChatSave', 'CopilotChatLoad', 'CopilotChatPrompts', 'CopilotChatModels' },
    build = 'make tiktoken',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {},
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown', 'opencode_output' },
    cmd = 'RenderMarkdown',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },
    opts = { anti_conceal = { enabled = false }, file_types = { 'markdown', 'opencode_output' } },
  },
}
