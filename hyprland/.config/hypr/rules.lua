hl.workspace_rule({ workspace = "w[tv1]s[false]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]s[false]", gaps_out = 0, gaps_in = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]s[false]" }, border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]s[false]" }, rounding = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]s[false]" }, border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]s[false]" }, rounding = 0 })

hl.window_rule({
	name = "privacy-browsers-float",
	match = { class = "^(Tor Browser|Mullvad Browser)$" },
	float = true,
	center = true,
	fullscreen_state = "0 0",
	suppress_event = "maximize",
})

hl.window_rule({
	name = "suppress-maximize",
	suppress_event = "maximize",
	match = { class = ".*" },
})

hl.window_rule({
	name = "hide-empty-xwayland",
	no_focus = true,
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
})

hl.window_rule({
	name = "mpv-float",
	match = { class = "^(mpv)$" },
	float = true,
})

hl.window_rule({
	name = "pavucontrol-float",
	match = { class = "^(org\\.pulseaudio\\.pavucontrol)$" },
	float = true,
	size = "800 500",
	center = true,
})
