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
  -- {
  --   'echasnovski/mini.pairs',
  --   --event = "VeryLazy",
  --   keys = {
  --     { '{', mode = 'i' },
  --     { '[', mode = 'i' },
  --     { '(', mode = 'i' },
  --     { '<', mode = 'i' },
  --     { '"', mode = 'i' },
  --     { "'", mode = 'i' },
  --   },
  --   opts = {},
  -- },

  -- Autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    keys = {
      { '{', mode = 'i' },
      { '[', mode = 'i' },
      { '(', mode = 'i' },
      { '<', mode = 'i' },
      { '"', mode = 'i' },
      { "'", mode = 'i' },
    },
    opts = {}
  },

  -- Matchup
  -- {
  --   "andymass/vim-matchup",
  --   event = "VeryLazy",
  --   init = function()
  --     vim.g.matchup_matchparen_offscreen = { method = "popup" }
  --     -- vim.g.matchup_matchparen_offscreen = { method = "status" }
  --   end,
  --   keys = {
  --     { 'gJ', mode = { 'n', 'x' } },
  --     { 'gK', mode = { 'n', 'x' } },
  --   },
  -- }
}
