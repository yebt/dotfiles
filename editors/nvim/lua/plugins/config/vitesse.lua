return function()
  require('vitesse').setup({
    comment_italics = true,
    transparent_background = false,
    transparent_float_background = false, -- aka pum(popup menu) background
    reverse_visual = false,
    dim_nc = false,
    cmp_cmdline_disable_search_highlight_group = false, -- disable search highlight group for cmp item
    -- if `transparent_float_background` false, make telescope border color same as float background
    telescope_border_follow_float_background = false,
    -- diagnostic virtual text background, like error lens
    diagnostic_virtual_text_background = false,
  })


  -- Set new colorschemes
  vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
      -- vim.api.nvim_set_hl(0, "CursorLineNr", { cterm = bold, bold = true })
      local c = vim.api.nvim_get_hl_by_name("StatusLine", true)
      -- 
      vim.api.nvim_set_hl(0, "StatusLine", { fg = "#BFFFF1", bg = c.background })
      vim.api.nvim_set_hl(0, "Visual", { bg = "#252525"})
      -- vim.api.nvim_set_hl(0, "Visual", { bg = "#000000"})
      -- vim.notify(vim.inspect(c))
    end,
  })

  -- #252525
  -- #BFFFF1
  -- #FF934F
  -- #C2E812
  -- #FBBFCA
end
