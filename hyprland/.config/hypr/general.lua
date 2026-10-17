local hs = require("hyprsplit")
hl.env("XCURSOR_THEME", "Qogir-Manjaro-cursors")
hl.env("XCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("GTK_THEME", "Tokyonight-Dark")

hs.config({
	num_workspaces = 5,
	persistent_workspaces = true,
})

hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 10,
		border_size = 1,
		resize_on_border = false,
		allow_tearing = false,
		layout = "dwindle",
		col = {
			active_border = "rgba(bdadeabf)",
			inactive_border = "rgba(4e4c67bf)",
		},
		snap = {
			enabled = true,
			respect_gaps = true,
		},
	},

	dwindle = {
		preserve_split = true,
		force_split = 2,
	},

	decoration = {
		rounding = 0,
		shadow = { enabled = false },
		blur = {
			enabled = true,
			passes = 1,
			size = 3,
			vibrancy = 0.1696,
			xray = true,
		},
	},

	input = {
		accel_profile = "flat",
		follow_mouse = 2,
		numlock_by_default = true,
		repeat_delay = 400,
	},

	misc = { disable_hyprland_logo = true },
	animations = { enabled = false },
	cursor = { no_warps = true },
	ecosystem = { no_update_news = true, no_donation_nag = true },
})
