local api = vim.api
local util = vim.lsp.util

-- Functions

--
local function has_capability(capability, filter)
  for _, client in ipairs(vim.lsp.get_active_clients(filter)) do
    if client.supports_method(capability) then
      return true
    end
  end
  return false
end

--
local function add_buffer_autocmd(augroup, bufnr, autocmds)
  if not vim.tbl_islist(autocmds) then
    autocmds = { autocmds }
  end
  local cmds_found, cmds = pcall(vim.api.nvim_get_autocmds, { group = augroup, buffer = bufnr })
  if not cmds_found or vim.tbl_isempty(cmds) then
    vim.api.nvim_create_augroup(augroup, { clear = false })
    for _, autocmd in ipairs(autocmds) do
      local events = autocmd.events
      autocmd.events = nil
      autocmd.group = augroup
      autocmd.buffer = bufnr
      vim.api.nvim_create_autocmd(events, autocmd)
    end
  end
end

--
local function del_buffer_autocmd(augroup, bufnr)
  local cmds_found, cmds = pcall(vim.api.nvim_get_autocmds, { group = augroup, buffer = bufnr })
  if cmds_found then
    vim.tbl_map(function(cmd)
      vim.api.nvim_del_autocmd(cmd.id)
    end, cmds)
  end
end

--
local function overwrite_format2(options)
  options = options or {}
  local bufnr = options.bufnr or api.nvim_get_current_buf()
  local method = 'textDocument/formatting'
  local clients = vim.lsp.get_active_clients({
    id = options.id,
    bufnr = bufnr,
    name = options.name,
    method = method,
  })

  if options.filter then
    clients = vim.tbl_filter(options.filter, clients)
  end
  -- filer if client.server_capabilities.documentFormattingProvider
  clients = vim.tbl_filter(function(client)
    return client.server_capabilities.documentFormattingProvider
  end, clients)

  if #clients == 0 then
    vim.notify('[LSP] Format request failed, no matching language servers.')
  end

  local copyClient = vim.deepcopy(clients)
  table.insert(copyClient, { name = 'all' })
  table.insert(copyClient, { name = 'Set default formatter' })

  --@private
  local function applyFormat(clientsi)
    if options.async then
      local do_format
      do_format = function(idx, client)
        if not client then
          return
        end
        -- local params = set_range(client, util.make_formatting_params(options.formatting_options))
        local params = util.make_formatting_params(options.formatting_options)
        client.request(method, params, function(...)
          local handler = client.handlers[method] or vim.lsp.handlers[method]
          handler(...)
          do_format(next(clientsi, idx))
        end, bufnr)
      end
      do_format(next(clientsi))
    else
      local timeout_ms = options.timeout_ms or 1000
      for _, client in pairs(clientsi) do
        local params = util.make_formatting_params(options.formatting_options)
        local result, err = client.request_sync(method, params, timeout_ms, bufnr)
        if result and result.result then
          util.apply_text_edits(result.result, bufnr, client.offset_encoding)
        end
        if err then
          vim.notify(string.format('[LSP][%s] %s', client.name, err), vim.log.levels.WARN)
        end
      end
    end
  end

  -- check if formatter is set
  if vim.g.defaultFormatClient then
    -- check if formatter is in list
    for _, client in pairs(clients) do
      if client.name == vim.g.defaultFormatClient then
        applyFormat({ client })
        return
      end
    end
    vim.notify('Default Formatter not found: ' .. vim.g.defaultFormatClient)
  end

  if #clients > 1 then
    vim.ui.select(copyClient, {
      prompt = 'Select a formatter:',
      format_item = function(item)
        return item.name
      end,
    }, function(choice)
      if not choice then
        vim.notify('No formatter selected')
      elseif choice.name == 'all' then
        applyFormat(clients)
      elseif choice.name == 'Set default formatter' then
        vim.ui.select(clients, {
          prompt = 'Select a formatter:',
          format_item = function(item)
            return item.name
          end,
        }, function(choicei)
          if not choicei then
            vim.notify('No formatter selected')
          else
            vim.notify('Set default formatter:' .. choicei.name)
            vim.g.defaultFormatClient = choicei.name
            applyFormat({ choicei })
          end
        end)
      elseif choice then
        applyFormat({ choice })
      end
    end)
  else
    applyFormat(clients)
  end
end

vim.diagnostic.config({
  underline = true,
  virtual_text = true,
  signs = true,
  float = {
    source = 'always',
  },
  update_in_insert = false,
})


-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { silent = true, desc = 'LSP: Open diagnostic float' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { silent = true, desc = 'LSP: Go to previous diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { silent = true, desc = 'LSP: Go to next diagnostic' })
-- vim.keymap.set("n", "<leader>E", vim.diagnostic.setloclist, { silent = true, desc = "Set loclist" })
vim.keymap.set('n', '<leader>E', ':TroubleToggle document_diagnostics<CR>', { silent = true, desc = 'LSP: Set loclist' })

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('_UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Vars
    local bufnr = ev.buf
    local client = vim.lsp.get_client_by_id(ev.data.client_id)

    -- Mapppings

    -- - textDocument/completion
    -- - textDocument/publishDiagnostics
    -- - window/logMessage
    -- - window/showMessage
    -- - window/showDocument
    -- - window/showMessageRequest
    -- - workspace/applyEdit
    -- - workspace/configuration
    -- - workspace/executeCommand

    --
    -- ## Code action
    -- if client.supports_method "textDocument/codeAction" then
    --		vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
    -- end
    -- Not need validtion
    vim.keymap.set(
      'n',
      '<leader>ca',
      ':Lspsaga code_action<CR>',
      { silent = true, buffer = bufnr, desc = 'LSP: Code action' }
    )

    -- ## Code lens
    -- Code lens
    -- if client.supports_method("textDocument/codeLens") then
    -- 	local auidCL = nil
    -- 	auidCL = vim.api.nvim_create_autocmd({ "InsertLeave", "BufEnter" }, {
    -- 		group = vim.api.nvim_create_augroup("_LspCodeLens", { clear = true }),
    -- 		desc = "Refresh codelens",
    -- 		callback = function()
    -- 			if client.supports_method("textDocument/codeLens") then
    -- 				vim.lsp.codelens.refresh()
    -- 			else
    -- 				vim.api.nvim_del_autochmd(auidCL)
    -- 			end
    -- 		end,
    -- 	})
    -- 	vim.lsp.codelens.refresh()
    -- 	vim.keymap.set("n", "<leader>cl", vim.lsp.codelens.run, { buffer = bufnr, desc = "LSP Code lens run" })
    -- end
    if client.supports_method('textDocument/codeLens') then
      add_buffer_autocmd('lsp_codelens_refresh', bufnr, {
        events = { 'InsertLeave', 'BufEnter' },
        desc = 'LSP: Refresh codelens',
        callback = function()
          if not has_capability('textDocument/codeLens', { bufnr = bufnr }) then
            del_buffer_autocmd('lsp_codelens_refresh', bufnr)
            return
          end
          vim.lsp.codelens.refresh()
        end,
      })
      vim.lsp.codelens.refresh()
    end

    -- ## Declarations
    -- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    if client.supports_method('textDocument/declaration') then
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr, desc = 'LSP: Declaration of current symbol' })
    end

    -- ## Definitions
    -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    if client.supports_method('textDocument/definition') then
      -- vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "LSP Definition of current symbol" })
      vim.keymap.set(
        'n',
        'gd',
        ': Lspsaga goto_definition<CR>',
        { buffer = bufnr, desc = 'LSP: Definition of current symbol' }
      )
    end

    -- ## Formatting
    if client.supports_method('textDocument/formatting') then
      vim.keymap.set({ 'n', 'v' }, '<leader>f', function()
        -- vim.lsp.buf.format { async = true }
        local formatting_options = {
          -- options = {
          --   tabSize = vim.lsp.util.get_effective_tabstop(),
          --       insertSpaces = true,
          -- },
          timeout_ms = 1000,
          bufnr = bufnr,
          -- filter = function(client)
          --   return true
          -- end,
          async = true,
        }
        overwrite_format2(formatting_options)
        -- async_formatting(bufnr)
      end, { buffer = bufnr, desc = 'LSP: Sync Format' })
    end

    -- ## Document highlight hover
    -- Move to illuminate
    -- if client.supports_method("textDocument/documentHighlight") then
    -- 	add_buffer_autocmd("lsp_document_highlight", bufnr, {
    -- 		{
    -- 			events = { "CursorHold", "CursorHoldI" },
    -- 			desc = "highlight references when cursor holds",
    -- 			callback = function()
    -- 				if not has_capability("textDocument/documentHighlight", { bufnr = bufnr }) then
    -- 					del_buffer_autocmd("lsp_document_highlight", bufnr)
    -- 					return
    -- 				end
    -- 				vim.lsp.buf.document_highlight()
    -- 			end,
    -- 		},
    -- 		{
    -- 			events = { "CursorMoved", "CursorMovedI" },
    -- 			desc = "clear references when cursor moves",
    -- 			callback = function()
    -- 				vim.lsp.buf.clear_references()
    -- 			end,
    -- 		},
    -- 	})
    --
    -- 	-- local dhg = vim.api.nvim_create_augroup("_LspDocumentHihlight", { clear = true })
    -- 	-- local auidDH = nil
    -- 	-- auidDH = vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    -- 	-- 	group = dhg,
    -- 	-- 	desc = "highlight references when cursor holds",
    -- 	-- 	callback = function()
    -- 	-- 	  vim.notify(vim.inspect(auidDH))
    -- 	-- 		if client.supports_method("textDocument/documentHighlight") then
    -- 	-- 			vim.lsp.buf.document_highlight()
    -- 	-- 		else
    -- 	-- 			vim.api.nvim_del_autochmd(auidDH)
    -- 	-- 		end
    -- 	-- 	end,
    -- 	-- })
    -- 	-- vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    -- 	-- 	group = dhg,
    -- 	-- 	desc = "clear references when cursor moves",
    -- 	-- 	callback = function()
    -- 	-- 		vim.lsp.buf.clear_references()
    -- 	-- 	end,
    -- 	-- })
    -- end

    -- ## Hover
    -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    if client.supports_method('textDocument/hover') then
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr, desc = 'LSP: Hover' })
    end

    -- ## Implementation
    -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    if client.supports_method('textDocument/implementation') then
      vim.keymap.set(
        'n',
        'gi',
        vim.lsp.buf.implementation,
        { buffer = bufnr, desc = 'LSP: Implementation of current symbol' }
      )
    end

    -- ## Inlay hints toggle
    if client.supports_method('textDocument/inlayHint') then
      if vim.lsp.inlay_hint then
        vim.keymap.set('n', '<leader>ih', function()
          vim.b.inlay_hints_enabled = not vim.b.inlay_hints_enabled
          vim.lsp.inlay_hint(bufnr or 0, vim.b.inlay_hints_enabled)
          vim.notify('Inlay hints ' .. (vim.b.inlay_hints_enabled and 'enabled' or 'disabled'))
        end, { buffer = bufnr, desc = 'LSP: Inlay hints toggle' })
        vim.b.inlay_hints_enabled = not vim.b.inlay_hints_enabled
        vim.lsp.inlay_hint(bufnr or 0, vim.b.inlay_hints_enabled)
      end
    end

    -- ## References
    -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    if client.supports_method('textDocument/references') then
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = bufnr, desc = 'LSP: References of current symbol' })
    end

    -- ## Rename
    -- vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    if client.supports_method('textDocument/rename') then
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = bufnr, desc = 'LSP: Rename current symbol' })
    end

    -- ## Signature help
    -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    if client.supports_method('textDocument/signatureHelp') then
      vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, { buffer = bufnr, desc = 'LSP: Signature help' })
    end

    -- ## Type definition
    -- vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
    if client.supports_method('textDocument/typeDefinition') then
      vim.keymap.set(
        'n',
        '<leader>D',
        ': Lspsaga goto_type_definition<CR>',
        { buffer = bufnr, desc = 'LSP: Type definition of current symbol' }
      )
    end

    -- ## Workspace symbols
    -- vim.keymap.set('n', '<leader>Ws', vim.lsp.buf.workspace_symbol, opts)
    if client.supports_method('workspace/symbol') then
      vim.keymap.set(
        'n',
        '<leader>Ws',
        vim.lsp.buf.workspace_symbol,
        { buffer = bufnr, desc = 'LSP: Workspace symbols' }
      )
    end

    -- ## Workspace add folder
    -- vim.keymap.set('n', '<leader>Wa', vim.lsp.buf.add_workspace_folder, opts)
    if client.supports_method('workspace/workspaceFolders') then
      vim.keymap.set(
        'n',
        '<leader>Wa',
        vim.lsp.buf.add_workspace_folder,
        { buffer = bufnr, desc = 'LSP: Add workspace folder' }
      )
    end

    -- ## Workspace remove folder
    -- vim.keymap.set('n', '<leader>Wr', vim.lsp.buf.remove_workspace_folder, opts)
    if client.supports_method('workspace/workspaceFolders') then
      vim.keymap.set(
        'n',
        '<leader>Wr',
        vim.lsp.buf.remove_workspace_folder,
        { buffer = bufnr, desc = 'LSP: Remove workspace folder' }
      )
    end

    -- ## Workspace list folders
    -- vim.keymap.set('n', '<leader>Wl', function()
    --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    -- end, opts)
    if client.supports_method('workspace/workspaceFolders') then
      vim.keymap.set('n', '<leader>Wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, { buffer = bufnr, desc = 'LSP: List workspace folders' })
    end

    -- ## Semantic tokens
    -- textDocument/semanticTokens/full
    if client.supports_method('textDocument/semanticTokens/full') then
      -- vim.b.semantic_tokens_enabled = true
      vim.keymap.set('n', '<leader>St', function()
        vim.b.semantic_tokens_enabled = not vim.b.semantic_tokens_enabled
        vim.lsp.semantic_tokens[vim.b.semantic_tokens_enabled and 'start' or 'stop'](bufnr or 0, client.id)
        vim.notify('Semantic tokens ' .. (vim.b.semantic_tokens_enabled and 'enabled' or 'disabled'))
      end, { buffer = bufnr, desc = 'LSP: Semantic tokens' })
    end

    -- ## incoming calls
    vim.keymap.set(
      'n',
      '<leader>ic',
      -- vim.lsp.buf.incoming_calls,
      ':Lspsaga incoming_calls<CR>',
      { buffer = bufnr, desc = 'LSP: Incoming calls of current symbol' }
    )
    -- ## outgoing calls
    vim.keymap.set(
      'n',
      '<leader>oc',
      -- vim.lsp.buf.outgoing_calls,
      ':Lspsaga outgoing_calls<CR>',
      { buffer = bufnr, desc = 'LSP: Outgoing calls of current symbol' }
    )
  end,
})
