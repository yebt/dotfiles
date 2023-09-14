--
local stts_str=""

--
local padding = '%#Normal# %0*' -- xpadding
local separator = "%=" -- separator

-- append var
function _G.append_v(v, chrl, chrr, vl)
  if v and v ~= '' then
    return chrl .. v .. chrr .. ' '
  else
    return vl or ''
  end
end

-- Get tthe lazypdates
function _G.Lazyupdates()
  local ok, lst = pcall(require, 'lazy.status')
  if not ok then
    return ''
  end
  if lst.has_updates() then
    return ' ' .. require('lazy.status').updates() .. ' '
  end
  return ''
end

--
stts_str = padding
  .. "%1*%{ v:lua.append_v(get(b:,'gitsigns_head',''),'  [', ']')}%0*"
  .. ' %<%f '
  .. '%h%m%r'
  .. separator
  -- diagnostic
  .. separator
  .. '%2*%{v:lua.Lazyupdates()}%0*' -- Updates
  .. ' %2l/%L:%c '
  --.. '%{ mode() }'
  .. padding
--
vim.opt.statusline = stts_str
--