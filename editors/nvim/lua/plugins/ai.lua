return {

	-- Coduim
	{
		"Exafunction/codeium.vim",
		--event = "VeryLazy",
		event = "InsertEnter",
		--event = 'BufEnter'
		keys = {
			{
				"<Tab>",
				mode = { "i" },
				function()
					return vim.fn["codeium#Accept"]()
				end,
				expr = true,
			},
			{
				"<C-]>",
				mode = { "i" },
				function()
					return vim.fn["codeium#Clear"]()
				end,
				expr = true,
			},
			{
				"<M-]>",
				mode = { "i" },
				function()
					return vim.fn["codeium#CycleCompletions"](1)
				end,
				expr = true,
			},
			{
				"<M-[>",
				mode = { "i" },
				function()
					return vim.fn["codeium#CycleCompletions"](-1)
				end,
				expr = true,
			},
		},
	},
}
