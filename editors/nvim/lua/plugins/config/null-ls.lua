return function ()
	local null_ls = require("null-ls")
	local masonnullls = require("mason-null-ls")

	masonnullls.setup({
		ensure_installed = {
			ensure_installed = { "stylua", "jq" },
		},
		automatic_installation = false,
		handlers = {},
	})

	null_ls.setup({
		sources = {
			-- Code actions
			null_ls.builtins.code_actions.eslint,
			null_ls.builtins.code_actions.gitsigns,
			-- Completinons
			null_ls.builtins.completion.spell
			-- Diagnostics
			-- Formatting
			-- Hover
		},
	})
end
