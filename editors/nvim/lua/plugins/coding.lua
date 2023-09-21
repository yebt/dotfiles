return {

  -- comment to
  {
    'echasnovski/mini.comment',
    --event = 'VeryLazy',
    keys = {
      { 'gc', mode = { 'n', 'x' } },
    },
    opts = {
      options = {
        custom_commentstring = function()
          return require('ts_context_commentstring.internal').calculate_commentstring() or vim.bo.commentstring
        end,
      },
    },
  },

  -- auto pairs
  {
    'echasnovski/mini.pairs',
    --event = "VeryLazy",
    keys = {
      { '{', mode = 'i' },
      { '[', mode = 'i' },
      { '(', mode = 'i' },
      { '<', mode = 'i' },
      { '"', mode = 'i' },
      { "'", mode = 'i' },
    },
    opts = {},
  },
}
