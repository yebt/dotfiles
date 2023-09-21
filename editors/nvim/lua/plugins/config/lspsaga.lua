return function ()
	local lspsaga = require("lspsaga")

	lspsaga.setup({
		breadcrups = {
			enable = true,
		},
		-- callhierarchy --> :Lspsaga incoming_calls and :Lspsaga outgoing_calls

		-- LightBulb
		lightbulb = {
			enable = false,
		},
	})

	-- vim.keymap.set('n','t', '<A-d>', '<cmd>Lspsaga term_toggle',{})
end
