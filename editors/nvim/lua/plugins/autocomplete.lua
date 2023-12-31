return {
  -- snippets
  {
    'L3MON4D3/LuaSnip',
    event = 'InsertEnter',

    build = (not jit.os:find('Windows')) and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp" or nil,
    dependencies = {
      'rafamadriz/friendly-snippets',
      config = function()
        require('luasnip.loaders.from_vscode').lazy_load()
        require'luasnip'.filetype_extend("vue", {"vue"})
      end,
    },
    opts = {
      history = true,
      delete_check_events = 'TextChanged',
    },
    keys = {
      {
        '<C-l>',
        function()
          return require('luasnip').jumpable(1) and '<Plug>luasnip-jump-next' or '<tab>'
        end,
        expr = true,
        silent = true,
        mode = 'i',
      },
      {
        '<C-l>',
        function()
          require('luasnip').jump(1)
        end,
        mode = 's',
      },
      {
        '<C-h>',
        function()
          require('luasnip').jump(-1)
        end,
        mode = { 'i', 's' },
      },
    },
  },

  -- auto completion
  {
    'hrsh7th/nvim-cmp',
    --version = false, -- last release is way too old
    event = 'InsertEnter',
    dependencies = {
      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'saadparwaiz1/cmp_luasnip',
      --
      'hrsh7th/cmp-nvim-lsp-signature-help',
      --
      { 'jackieaskins/cmp-emmet', build = 'npm run release' },
      --
      'onsails/lspkind.nvim',
    },
    opts = function()
      vim.api.nvim_set_hl(0, 'CmpGhostText', { link = 'Comment', default = true })
      local cmp = require('cmp')
      local lspkind = require('lspkind')
      local defaults = require('cmp.config.default')()
      return {
        completion = {
          -- autocomplete = false,
          completeopt = 'menu,menuone,noinsert',
        },
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ['<S-CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp_signature_help' },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'emmet' },
          { name = 'buffer' },
          { name = 'path' },
        }),
        -- formatting = {
        --   format = function(_, item)
        --     local icons = require('lazyvim.config').icons.kinds
        --     if icons[item.kind] then
        --       item.kind = icons[item.kind] .. item.kind
        --     end
        --     return item
        --   end,
        -- },
        formatting = {
          format = lspkind.cmp_format({
            mode = 'symbol_text',
            menu = {
              buffer = '[Buffer]',
              nvim_lsp = '[LSP]',
              luasnip = '[LuaSnip]',
              nvim_lua = '[Lua]',
              latex_symbols = '[Latex]',
            },
          }),
        },

        -- experimental = {
        --   ghost_text = {
        --     hl_group = 'CmpGhostText',
        --   },
        -- },
        sorting = defaults.sorting,
      }
    end,
  },
}
