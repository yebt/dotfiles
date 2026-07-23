-- Edited by @walo

--- ===== MONITOR =====
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = 1, -- cause 'auto' us too smal
})

--- ===== GLOBALS =====
local pref_terminal = "alacritty"
--local pref_menu = "hyprlauncher"
local pref_menu = "wofi --show run"
local mod_key = "SUPER"

local wobsock = "$XDG_RUNTIME_DIR/wob.sock"

--- ===== GENERAL =====
hl.config({
	general = {
		-- "dwindle"/"master"/"scrolling"/"monocle"
		-- layout = monocle,
		gaps_in = 5,
		gaps_out = 8,
		border_size = 1,
	},
	decoration = {
		rounding = 4,
	},
	input = {
		kb_layout = "us",
		kb_variant = "altgr-intl",

		follow_mouse = 1,
		natural_scroll = true,
		repeat_delay = 200,
		touchpad = {
			natural_scroll = true,
			disable_while_typing = true,
		},
	},
	-- animations = {
	-- 		enabled = false
	-- },

	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
	},
})

---
---hl.curve( NAME, { type = "bezier", points = { {X0, Y0}, {X1, Y1} } })

-- https://easings.net/
hl.curve("overshoot", { type = "bezier", points = { { 0.5, 0.9 }, { 0.1, 1.1 } } })
hl.curve("easeOutCubic", { type = "bezier", points = { { 0.3, 1 }, { 0.68, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0 }, { 0.35, 1 } } })
hl.curve("easeOutExpo", { type = "bezier", points = { { 0.16, 1 }, { 0.3, 1 } } })
hl.curve("easeInOutBack", { type = "bezier", points = { { 0.68, -0.6 }, { 0.32, 1.6 } } })
hl.curve("easeOutBack", { type = "bezier", points = { { 0.34, 1.56 }, { 0.64, 1 } } })

-- hl.curve( "rubber", { type = "spring", mass = 1, stiffness = 70, dampening = 10 } )

hl.animation({
	leaf = "windows",
	enabled = true,
	speed = 4,
	bezier = "easeOutBack",
	curve = "default",
	style = "popin 80%",
})
hl.animation({
	leaf = "workspaces",
	enabled = true,
	speed = 4,
	bezier = "easeOutExpo",
})

hl.animation({ leaf = "layers", speed = 3, enabled = 0, bezier = "easeOutExpo" })
hl.animation({ leaf = "fade", speed = 3, enabled = true, bezier = "easeOutExpo" })

---
hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})
hl.gesture({
	fingers = 3,
	direction = "up",
	action = "fullscreen",
})

hl.gesture({
	fingers = 2,
	direction = "pinch",
	action = "cursorZoom",
})

-- hl.animation({ leaf = "global", enabled = false })

--- ===== AUTOSTARTS=====

-- Wallpapers
-- hl.exec_cmd("killall swaybg ||  pkill .swaybg-wrapped ; swaybg -i ~/Pictures/wallpapers/wallhaven-w5d8jr.jpg &") -- Wallpapers
-- services
hl.on("hyprland.start", function()
	local services = {
		"hyprpolkitagent", -- Polkit agent
		"mako", -- Notifications
		-- "hyprpaper",				-- Wallpapers
		"swaybg -i ~/Pictures/wallpapers/wallhaven-w5d8jr.jpg", -- Wallpapers
		"wl-paste --watch cliphist store", -- Clipboard history
		"hypridle", -- Lock system
		"waybar", -- bar
		"nm-applet",
	}

	for _, cmd in ipairs(services) do
		hl.exec_cmd(cmd)
	end

	-- bars
	hl.exec_cmd("rm -f " .. wobsock .. " && mkfifo " .. wobsock .. " && tail -f " .. wobsock .. " | wob")

	-- STARTER APPS
	-- hl.exec_cmd("hyprctl dispatch exec '[workspace 3 silent] firefox'")
end)

--- ===== AUX FUNCTIONS =====
local function bind_base(key, action, flags)
	flags = flags or {}
	hl.bind(mod_key .. " + " .. key, action, flags)
end
local function bind_exec(key, action, flags)
	bind_base(key, hl.dsp.exec_cmd(action), flags)
end

--- ===== BINDINGS =====

-- Quit
hl.bind(
	mod_key .. " + SHIFT + E",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)

bind_exec("SHIFT + L", "hyprlock")

-- Fast actions
bind_exec("RETURN", pref_terminal)
bind_base("SHIFT + RETURN", hl.dsp.exec_cmd(pref_terminal, { float = true, center = true, size = { 1000, 700 } }))
--hl.bind("SUPER + E", hl.dsp.exec_cmd(pref_terminal, { float = true, move = {0, 0} }))
bind_exec("D", pref_menu)

--bind_exec("P", "cliphist list | wofi | cliphist decode ")
bind_exec("P", "~/.config/hypr/scripts/clip_history.sh w")
bind_exec("M", "pkill waybar || waybar")

-- Workspaces base maping
for indx = 1, 9 do
	local key = indx % 10 -- To start in 0
	bind_base(
		key,
		hl.dsp.focus({
			workspace = indx,
		})
	)
	bind_base(
		"SHIFT + " .. key,
		hl.dsp.window.move({
			workspace = indx,
		})
	)
end
-- last workspace
--bind_base( "SHIFT + w", hl.dsp.focus({ workspace = "last" }))
bind_base(
	"TAB",
	hl.dsp.focus({
		workspace = "previous",
	})
)

-- Focus
local action = {
	"left",
	"right",
	"up",
	"down",
}
for _, act in ipairs(action) do
	bind_base(
		act,
		hl.dsp.focus({
			direction = act,
		})
	)
	bind_base(
		"SHIFT + " .. act,
		hl.dsp.window.move({
			direction = act,
		})
	)
end

-- Scratchpad
bind_base("minus", hl.dsp.workspace.toggle_special("scratchpad"))
bind_base(
	"SHIFT + minus",
	hl.dsp.window.move({
		workspace = "special:scratchpad",
	})
)

--

-- Go to last workspace
-- Floating

-- MEDIA
local function bind_fun_map(key, exec)
	hl.bind(key, hl.dsp.exec_cmd(exec), { locked = true, repeating = true })
end

bind_fun_map(
	"XF86AudioRaiseVolume",
	"wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 2%+ && wpctl get-volume @DEFAULT_AUDIO_SINK@ | sed 's/[^0-9]//g' > "
		.. wobsock
)
bind_fun_map(
	"XF86AudioLowerVolume",
	"wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%- && wpctl get-volume @DEFAULT_AUDIO_SINK@ | sed 's/[^0-9]//g' > "
		.. wobsock
)
bind_fun_map("XF86AudioMute", "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
bind_fun_map("XF86AudioMicMute", "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle")

bind_fun_map(
	"XF86MonBrightnessUp",
	"brightnessctl -e4 -n2 set 5%+ | sed -En 's/.*\\(([0-9]+)%\\).*/\\1/p' > " .. wobsock
)
bind_fun_map(
	"XF86MonBrightnessDown",
	"brightnessctl -e4 -n2 set 5%- | sed -En 's/.*\\(([0-9]+)%\\).*/\\1/p' > " .. wobsock
)

bind_fun_map("XF86AudioNext", "playerctl next")
bind_fun_map("XF86AudioPause", "playerctl play-pause")
bind_fun_map("XF86AudioPlay", "playerctl play-pause")
bind_fun_map("XF86AudioPrev", "playerctl previous")

bind_fun_map("PRINT", "hyprshot -m output -m active") -- Capture monitor
bind_exec("PRINT", "hyprshot -m window") -- Capture window
bind_fun_map("SHIFT + PRINT", "hyprshot -m region") -- Capture monitor
bind_exec("SHIFT + PRINT", "hyprshot -m region --clipboard-only") -- Capture monitor

-- windows
-- KMB/RMB
bind_base("mouse:272", hl.dsp.window.drag(), {
	mouse = true,
})
bind_base("mouse:273", hl.dsp.window.resize(), {
	mouse = true,
})

-- Floating
bind_base(
	"SHIFT + SPACE",
	hl.dsp.window.float({
		action = "toggle",
	}),
	{
		mouse = true,
	}
)
bind_base("SHIFT + Q", hl.dsp.window.close())
bind_base(
	"f",
	hl.dsp.window.fullscreen({
		mode = "maximized",
		action = "toggle",
	})
)
bind_base("c", function()
	hl.dispatch(hl.dsp.window.resize({
		x = 1100,
		y = 800,
	}))
	hl.dispatch(hl.dsp.window.center())
end)

-- Modes
local mode_resize = "resize"
bind_base("R", hl.dsp.submap(mode_resize))
hl.define_submap(mode_resize, function()
	--bind_base( "", hl.dsp.window.resize( { x = 10, y = 0, relative = true }, { repeating = true })
	local function bind_resize(key_act, x, y)
		hl.bind(
			key_act,
			hl.dsp.window.resize({
				x = x,
				y = y,
				relative = true,
			}),
			{
				repeating = true,
			}
		)
	end
	bind_resize("right", 10, 0)
	bind_resize("left", -10, 0)
	bind_resize("up", 0, 10)
	bind_resize("down", 0, -10)
	--
	hl.bind("ESCAPE", hl.dsp.submap("reset"))
end)

--- ===== RULES =====

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful
local suppressMaximizeRule = hl.window_rule({
	-- Ignore maximize requests from all apps. You'll probably like this.
	name = "suppress-maximize-events",
	match = {
		class = ".*",
	},
	suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)
hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	-- no_focus = true,
})

hl.window_rule({
	name = "Pictur in Picture",
	match = {
		title = "Picture-in-Picture",
	},
	border_size = 2,
	float = true,

	size = { 400, 225 },
	move = {
		"monitor_w - 400 -10",
		"monitor_h - 225 -10",
	},
})

hl.window_rule({
	name = "move-kitty",
	match = { class = "kitty" },
	move = { 100, 100 },
	animation = "popin",
})

---

hl.window_rule({
	name = "windowrule-1",
	match = {
		class = "^(thunar)$",
		title = "^(File Operation Progress)$",
	},
	float = true,
	--center = true,
})

hl.window_rule({
	name = "windowrule-2",
	match = {
		class = "^(thunar)$",
		title = "^(Rename.*)$",
	},
	float = true,
	center = false,
})

hl.window_rule({
	name = "windowrule-3",
	match = {
		class = "^(thunar)$",
		title = "^(Confirm to replace files)$",
	},
	float = true,
	center = true,
})

hl.window_rule({
	name = "windowrule-4",
	match = {
		class = "^(thunar)$",
		title = "^(Attention)$",
	},
	float = true,
	center = true,
})

-- 4. PROPERTIES
-- Matches "Properties"
hl.window_rule({
	name = "windowrule-5",
	match = {
		class = "^(thunar)$",
		title = "^(.*Properties)$",
	},
	float = true,
	center = true,
})

-- 5. CREATE NEW (Folder/File)
-- Matches "Create New Folder" or "Create Document"
hl.window_rule({
	name = "windowrule-6",
	match = {
		class = "^(thunar)$",
		title = "^(Create.*)$",
	},
	float = true,
	center = true,
})

-- 6. TRASH & PERMISSIONS
hl.window_rule({
	name = "windowrule-7",
	match = {
		class = "^(thunar)$",
		title = "^(Trash)$",
	},
	float = true,
	center = true,
})

hl.window_rule({
	name = "windowrule-8",
	match = {
		class = "^(thunar)$",
		title = "^(Authentication)$",
	},
	float = true,
	center = true,
})

-- gtk
hl.window_rule({
	name = "windowrule-9",
	match = {
		class = "^(xdg-desktop-portal-gtk)$",
	},
	float = true,
	center = true,
	size = { 900, 600 },
})

--- Chrome
hl.window_rule({
	name = "windowrule-10",
	match = {
		class = "^(chrome-.*)$",
		initial_title = "^(_crx_.*)$",
	},
	float = true,
	center = true,
	animation = "slide",
})
