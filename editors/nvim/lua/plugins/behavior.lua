return {
  -- Better practices
  {
    'm4xshen/hardtime.nvim',
    lazy = false,
    dependencies = { 'MunifTanjim/nui.nvim', 'nvim-lua/plenary.nvim' },
    opts = {
      disable_mouse = false,
      disabled_filetypes = { 'qf', 'netrw', 'NvimTree', 'lazy', 'mason', 'neo-tree', 'DressingInput', 'Telescope' },
      resetting_keys = {
        ["1"] = { "n", "x" },
        ["2"] = { "n", "x" },
        ["3"] = { "n", "x" },
        ["4"] = { "n", "x" },
        ["5"] = { "n", "x" },
        ["6"] = { "n", "x" },
        ["7"] = { "n", "x" },
        ["8"] = { "n", "x" },
        ["9"] = { "n", "x" },
        -- ["c"] = { "n" },
        -- ["C"] = { "n" },
        ["d"] = { "n" },
        ["x"] = { "n" },
        ["X"] = { "n" },
        ["y"] = { "n" },
        ["Y"] = { "n" },
        ["p"] = { "n" },
        ["P"] = { "n" },
        ["gp"] = { "n" },
        ["gP"] = { "n" },
        ["."] = { "n" },
        ["="] = { "n" },
        ["<"] = { "n" },
        [">"] = { "n" },
        ["J"] = { "n" },
        ["gJ"] = { "n" },
        ["~"] = { "n" },
        ["g~"] = { "n" },
        ["gu"] = { "n" },
        ["gU"] = { "n" },
        ["gq"] = { "n" },
        ["gw"] = { "n" },
        ["g?"] = { "n" },
      },
    },
  },

  -- Colorize view
  {
    'NvChad/nvim-colorizer.lua',
    -- event = "FileEnter",
    cmd = { 'ColorizerToggle', 'ColorizerAttachToBuffer', 'ColorizerDetachFromBuffer', 'ColorizerReloadAllBuffers' },
    keys = {
      { '<leader>zc', 'ColorizerToggle' },
    },
    opts = { user_default_options = { names = false } },
  },

  -- Session management. This saves your session in the background,
  -- keeping track of open buffers, window arrangement, and more.
  -- You can restore sessions when returning through the dashboard.
  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = { options = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help', 'globals', 'skiprtp' } },
    -- stylua: ignore
    keys = {
      { "<leader>ss", function() require("persistence").load() end,                desc = "Restore Session" },
      { "<leader>sl", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>sd", function() require("persistence").stop() end,                desc = "Don't Save Current Session" },
    },
  },

  -- which key
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {},
  },

  -- gitsigns
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      signs = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '▎' },
        untracked = { text = '▎' },
      },
    },
  },

  -- Finds and lists all of the TODO, HACK, BUG, etc comment
  -- in your project and loads them into a browsable list.
  {
    'folke/todo-comments.nvim',
    cmd = { 'TodoTrouble', 'TodoTelescope' },
    event = { 'BufReadPost', 'BufNewFile' },
    config = true,
    -- stylua: ignore
    -- keys = {
    --   { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
    --   { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
    --   { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
    --   { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
    --   { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
    --   { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
    -- },
  },

  --
  -- File Tree view
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<M-b>", "<cmd>Neotree toggle<cr>" },
    },
    -- event = "VeryLazy",
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    init = function()
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("neo-tree")
        end
      end
    end,

    config = require("plugins.config.neotree"),
  },
  -- Indentation
  {
    "NMAC427/guess-indent.nvim",
    lazy = false,
    config = require("plugins.config.guess-indent"),
  },

  -- Tabular
  {
    "godlygeek/tabular",
    cmd = { "Tabularize", "Tab" },
  }
}
