return function(_, opts)
  if type(opts.ensure_installed) == 'table' then
    ---@type table<string, boolean>
    local added = {}
    opts.ensure_installed = vim.tbl_filter(function(lang)
      if added[lang] then
        return false
      end
      added[lang] = true
      return true
    end, opts.ensure_installed)
  end
  require('nvim-treesitter.configs').setup(opts)

  if load_textobjects then
    if opts.textobjects then
      for _, mod in ipairs({ 'move', 'select', 'swap', 'lsp_interop' }) do
        if opts.textobjects[mod] and opts.textobjects[mod].enable then
          local Loader = require('lazy.core.loader')
          Loader.disabled_rtp_plugins['nvim-treesitter-textobjects'] = nil
          local plugin = require('lazy.core.config').plugins['nvim-treesitter-textobjects']
          require('lazy.core.loader').source_runtime(plugin.dir, 'plugin')
          break
        end
      end
    end
  end
end
