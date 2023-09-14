--
--
local old_path=package.path
package.path = "/home/eb/.config/nvim/lua/settings/?.lua;" 
-- package.path = "/home/eb/.config/nvim/lua/settings/?.lua;" .. package.path

require("options")
require("netrw")
require("autocommands")
require("keymaps")
require("statusline")

package.path = old_path
