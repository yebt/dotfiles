return {
  -- search/replace in multiple files
  {
    'nvim-pack/nvim-spectre',
    cmd = 'Spectre',
    opts = { open_cmd = 'noswapfile vnew' },
    -- stylua: ignore
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
    },
  },

  -- 

  -- Telescope
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		cmd = "Telescope",
		keys = {
			{
				"<leader>T<space>",
				":Telescope<CR>",
				desc = "Open telescope",
			},
			{
				"<C-p>",
				function()
					require("telescope.builtin").find_files({
						prompt_prefix = " ",
						prompt_title = "",
						-- selection_caret = "* ",
						multi_icon = "- ",
						attach_mappings = function(_, map)
							map("i", "<ESC>", require("telescope.actions").close)
							return true
						end,
						results_title = false,
						sorting_strategy = "ascending",
						layout_strategy = "center",
						layout_config = {
							-- preview_cutoff = 1, -- Preview should always show (unless previewer = false)
							-- width = 0.5,
							width = 70,
							-- height = 12,
							-- -- preview_cutoff = 120,
							anchor = "N",
						},
						-- -- border = false,
						 border = true,
						 borderchars = {
						   prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
						   results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
						   preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
						 },
					})
				end,
				silent = true,
				desc = "Telescope fast ff",
			},
		},
	}
}
