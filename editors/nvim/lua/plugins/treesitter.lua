return {
  -- syntax highlighting.
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
        init = function()
          require('lazy.core.loader').disable_rtp_plugin('nvim-treesitter-textobjects')
          load_textobjects = true
        end,
      },
    },
    cmd = { 'TSUpdateSync' },
    keys = {
      { '<c-space>', desc = 'Increment selection' },
      { '<bs>', desc = 'Decrement selection', mode = 'x' },
    },
    ---@type TSConfig
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        'bash',
        'c',
        'html',
        'javascript',
        'jsdoc',
        'json',
        'lua',
        'luadoc',
        'luap',
        'markdown',
        'markdown_inline',
        'python',
        'query',
        'regex',
        'tsx',
        'typescript',
        'vim',
        'vimdoc',
        'yaml',
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-space>',
          node_incremental = '<C-space>',
          scope_incremental = false,
          node_decremental = '<bs>',
        },
      },
      context_commentstring = {
        enable = true,
      },
      autotag = {
        enable = true,
        enable_rename = true,
        enable_close = true,
        enable_close_on_slash = true,
        filetypes = {
          'html',
          'javascript',
          'typescript',
          'javascriptreact',
          'typescriptreact',
          'svelte',
          'vue',
          'tsx',
          'jsx',
          'rescript',
          'xml',
          'php',
          'markdown',
          'astro',
          'glimmer',
          'handlebars',
          'hbs',
        },
        skip_tags = {
          'area',
          'base',
          'br',
          'col',
          'command',
          'embed',
          'hr',
          'img',
          'slot',
          'input',
          'keygen',
          'link',
          'meta',
          'param',
          'source',
          'track',
          'wbr',
          'menuitem',
        },
      },
    },
    ---@param opts TSConfig
    config = require('plugins.config.treesitter'),
  },

  -- Comments
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
  },
  -- TsAutotag
  {
    'windwp/nvim-ts-autotag',
  },
}
