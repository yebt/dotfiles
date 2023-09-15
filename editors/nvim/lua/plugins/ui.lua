return {

  -- Dress ui
  {
    "stevearc/dressing.nvim",
    -- init = function() require("astronvim.utils").load_plugin_with_func("dressing.nvim", vim.ui, { "input", "select" }) end,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
    opts = {
      -- Default prompt string
      default_prompt = "> ",
      -- Can be 'left', 'right', or 'center'
      title_pos = "left",
      -- When true, <Esc> will close the modal
      insert_only = true,
      -- When true, input will start in insert mode.
      start_in_insert = true,
      -- These are passed to nvim_open_win
      border = "rounded",
      win_options = {
        -- Window transparency (0-100)
        winblend = 0,
        -- Disable line wrapping
        wrap = false,
        -- Indicator for when text exceeds window
        list = true,
        listchars = "precedes:…,extends:…",
        -- Increase this for more context when text scrolls off the window
        sidescrolloff = 0,
      },
      --input = { default_prompt = "➤ " },
      select = { backend = { "telescope", "builtin" } },
    },
  },

  -- Session management. This saves your session in the background,
  -- keeping track of open buffers, window arrangement, and more.
  -- You can restore sessions when returning through the dashboard.
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" } },
    -- stylua: ignore
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
  },
}
