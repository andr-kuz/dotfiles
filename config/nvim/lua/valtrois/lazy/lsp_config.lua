-- :Mason
return {
  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },
        mapping = cmp.mapping.preset.insert {
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<Tab>'] = cmp.mapping.confirm { select = true },
          ['<C-Space>'] = cmp.mapping.complete {},
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        },
      }
    end,
  },

  -- Mason for LSP installation
  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    keys = { { '<leader>m', '<cmd>Mason<cr>', desc = 'Mason' } },
    config = true,
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    opts = {
      ensure_installed = {
        'lua-language-server',
        'basedpyright',  -- Changed from 'pyright' to 'basedpyright'
        'beancount-language-server',
        'stylua',
        'debugpy',
      },
      run_on_start = true,
    },
  },

  -- LSP Configuration
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
      -- Enhanced capabilities from nvim-cmp
      local capabilities = vim.tbl_deep_extend(
        'force',
        vim.lsp.protocol.make_client_capabilities(),
        require('cmp_nvim_lsp').default_capabilities()
      )

      -- Configure LSP servers
      vim.lsp.config('lua_ls', {
        capabilities = capabilities,
        settings = {
          Lua = {
            completion = { callSnippet = 'Replace' },
            diagnostics = { globals = { 'vim' } },
            workspace = {
              library = vim.api.nvim_get_runtime_file('', true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      })

      vim.lsp.config('basedpyright', {  -- Changed from 'pyright'
        capabilities = capabilities,
        settings = {
          basedpyright = {  -- Note: settings key matches server name
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = 'workspace',
              useLibraryCodeForTypes = true,
              autoImportCompletions = true,
            },
          },
        },
      })

      vim.lsp.config('beancount', {
        capabilities = capabilities,
        cmd = { 'beancount-language-server', '--stdio' },
        filetypes = { 'beancount', 'bean' },
        root_markers = { '.git', '*.beancount', '*.bean' },
        init_options = {
          journal_file = vim.fn.expand('~/finance/main.beancount'),
        },
      })

      -- Enable servers
      vim.lsp.enable('lua_ls')
      vim.lsp.enable('basedpyright')  -- Changed from 'pyright'
      vim.lsp.enable('beancount')

      -- Keymaps on LSP attach
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          local bufnr = event.buf

          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
          end

          map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
          map('gr', vim.lsp.buf.references, '[G]oto [R]eferences')
          map('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
          map('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
          map('<leader>ds', vim.lsp.buf.document_symbol, '[D]ocument [S]ymbols')
          map('<leader>ws', vim.lsp.buf.workspace_symbol, '[W]orkspace [S]ymbols')
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('<leader>w', vim.diagnostic.open_float, 'Open diagnostic')

          -- Code action with proper context
          map('<leader>a', function()
            vim.lsp.buf.code_action({
              context = {
                only = {
                  'quickfix',
                  'refactor',
                  'refactor.extract',
                  'refactor.inline',
                  'refactor.rewrite',
                  'source',
                  'source.organizeImports',
                },
              },
              apply = true,
            })
          end, 'Code [A]ction')

          -- Document highlight
          if client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local group = vim.api.nvim_create_augroup('lsp-highlight-' .. bufnr, { clear = true })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = bufnr,
              group = group,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = bufnr,
              group = group,
              callback = vim.lsp.buf.clear_references,
            })
          end

          -- Inlay hints
          -- if client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          --   vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          -- end
        end,
      })
    end,
  },
}
