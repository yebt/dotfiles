--
-- fast require
local old_path = package.path
package.path = '/home/eb/.config/nvim/lua/settings/?.lua;'
-- package.path = "/home/eb/.config/nvim/lua/settings/?.lua;" .. package.path

-- Load settigns
require('keymaps')
require('options')
require('netrw')
require('autocommands')
require('lazybootstrap')
require('lazyworkspace')
require('statusline') -- use lazy in stats

-- restore path
package.path = old_path

-- Last event of lazy.nivm needed aditional event lo lazy all plugins
--
vim.api.nvim_create_autocmd({ 'User' }, {
  pattern = { 'VeryLazy' },
  callback = function(args)
    -- aditional filetype event on verylazy
    vim.api.nvim_exec_autocmds('FileType', {})
    -- Aditional requires
    --require("locals.statusline")

    -- vim.schedule(function()
    --   --require("locals.statusline")
    --   --vim.api.nvim_exec_autocmds('User', { pattern = 'PostVeryLazy' })
    -- end)
  end,
})
