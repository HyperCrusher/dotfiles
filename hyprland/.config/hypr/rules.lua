hl.workspace_rule({ workspace = "w[tv1]s[false]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]s[false]", gaps_out = 0, gaps_in = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]s[false]" }, border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]s[false]" }, rounding = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]s[false]" }, border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]s[false]" }, rounding = 0 })

hl.window_rule({
	name = "privacyBrowsersFloat",
	match = { class = "^(Tor Browser|Mullvad Browser)$" },
	float = true,
	center = true,
	fullscreen_state = "0 0",
	suppress_event = "maximize",
})

hl.window_rule({
	name = "suppressMaximize",
	suppress_event = "maximize",
	match = { class = ".*" },
})

hl.window_rule({
	name = "hideEmptyXwayland",
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
	name = "mpvFloat",
	match = { class = "^(mpv)$" },
	float = true,
})

hl.window_rule({
	name = "pavucontrolFloat",
	match = { class = "^(org\\.pulseaudio\\.pavucontrol)$" },
	float = true,
	size = "800 500",
	center = true,
})

hl.window_rule({
	name = "polkitFloat",
	match = { class = "^(org\\.kde\\.polkit-kde-authentication-agent-1)$" },
	float = true,
	center = true,
})

-- File pickers opened through the desktop portal
hl.window_rule({
	name = "portalFileDialogFloat",
	match = { class = "^(xdg-desktop-portal-gtk|org\\.freedesktop\\.impl\\.portal\\.desktop\\.kde)$" },
	float = true,
	size = "900 700",
	center = true,
})

hl.window_rule({
	name = "fileDialogFloat",
	match = {
		title = "^(Open File|Open Files|Open Folder|Select Folder|Save File|Save As|File Upload|Choose Files|Enter name of file to save to…)(.*)$",
	},
	float = true,
	size = "900 700",
	center = true,
})

hl.window_rule({
	name = "pictureInPicture",
	match = { title = "^(Picture-in-Picture)$" },
	float = true,
	pin = true,
	keep_aspect_ratio = true,
	no_initial_focus = true,
	size = "640 360",
	move = "monitor_w-660 monitor_h-380",
})

hl.window_rule({
	name = "gameTearing",
	match = { content = "^(game)$" },
	immediate = true,
})

hl.window_rule({
	name = "steamGameTearing",
	match = { class = "^(steam_app_\\d+)$" },
	immediate = true,
})
