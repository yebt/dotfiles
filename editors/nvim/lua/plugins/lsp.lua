return {

	-- Schenmes
	{
		"b0o/schemastore.nvim",
	},
	-- Pacakges
	{
		"williamboman/mason.nvim",
		--lazy = false,
		-- events = { "BufRead", "BufNewFile", "BufEnter", "VeryLazy" },
		-- events = { "VeryLazy" },
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
		},
		-- config = require("plugins.configs.mason"),
	},
	-- Servers config
	{
		"neovim/nvim-lspconfig",
		event = { "VeryLazy" },
		dependencies = {
			-- { "folke/neodev.nvim", opts = {} },
		},
		config = require("plugins.config.lsp"),
	},
	{
		"RRethy/vim-illuminate",
		event = "VeryLazy",
	},

	-- Formatter and linter
	{
		"jose-elias-alvarez/null-ls.nvim",
		dependencies = {
			"jay-babu/mason-null-ls.nvim",
			event = { "BufReadPre", "BufNewFile" },
			dependencies = {
				"williamboman/mason.nvim",
				"jose-elias-alvarez/null-ls.nvim",
			},
			config = require("plugins.config.null-ls"),
		},
	},

	-- Lsp wrapper
	{
		"nvimdev/lspsaga.nvim",
		event = "LspAttach",
		dependencies = {
			"nvim-treesitter/nvim-treesitter", -- optional
			"nvim-tree/nvim-web-devicons", -- optional
		},
		keys = {
			{ "<C-j>", mode = { "n", "t" }, "<cmd>Lspsaga term_toggle<CR>" },
		},
		config = require("plugins.config.lspsaga"),
	},
  -- This works with LSP, Treesitter, and regexp matching to find the other
  -- instances.
  {
    'RRethy/vim-illuminate',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { 'lsp' },
      },
    },
    config = require('plugins.config.vim-illuminate'),
    keys = {
      { ']]', desc = 'Next Reference' },
      { '[[', desc = 'Prev Reference' },
    },
  },

  -- better diagnostics list and others
  {
    'folke/trouble.nvim',
    cmd = { 'TroubleToggle', 'Trouble' },
    opts = { use_diagnostic_signs = true },
  },
}
