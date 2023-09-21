return function ()
	local mason = require("mason")
	local mason_lspconfig = require("mason-lspconfig")
	local lspconfig = require("lspconfig")
	-- local lint = require("lint")

	local capabilities = require("cmp_nvim_lsp").default_capabilities()

	capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities.textDocument.completion.completionItem.preselectSupport = true
	capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
	capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
	capabilities.textDocument.completion.completionItem.deprecatedSupport = true
	capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
	capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
	capabilities.textDocument.completion.completionItem.resolveSupport =
		{ properties = { "documentation", "detail", "additionalTextEdits" } }
	capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }

	local default_config = {}
	default_config.capabilities = capabilities

	mason.setup({
		ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
	})

	mason_lspconfig.setup({
		ensure_installed = { 
		  "lua_ls",
		},
		handlers = {
			function(server_name) -- default handler (optional)
				lspconfig[server_name].setup({ default_config })
			end,
			["lua_ls"] = function()
				default_config.settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				}
				lspconfig.lua_ls.setup(default_config)
			end,

			["jsonls"] = function()
				-- extend default config
				default_config.settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				}
				-- setup server
				lspconfig["jsonls"].setup(default_config)
			end,

			["yamlls"] = function()
				-- extend default config
				default_config.settings = {
					yaml = {
						schemaStore = {
							-- You must disable built-in schemaStore support if you want to use
							-- this plugin and its advanced options like `ignore`.
							enable = false,
						},
						schemas = require("schemastore").yaml.schemas(),
					},
				}
				-- setup server
				lspconfig["yamlls"].setup(default_config)
			end,
		},
	})

end
