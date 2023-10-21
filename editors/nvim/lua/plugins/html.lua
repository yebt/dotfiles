return {
  -- Rename tags
  {
    "AndrewRadev/tagalong.vim",
    event = "VeryLazy"
  },

  -- Close tags
	{
		"alvan/vim-closetag",
		event = "VeryLazy",
	},

	-- 
	

	-- Emmet to fast autocomplete
	{
	  "mattn/emmet-vim",
    event = "VeryLazy",
    init = function()
      vim.g.user_emmet_mode = 'i'
      vim.g.user_emmet_leader_key = '<c-z>'
    end,
    keys = {
      { '<c-e>', '<plug>(emmet-expand-abbr)', mode = 'i' }
    }
	}
}
