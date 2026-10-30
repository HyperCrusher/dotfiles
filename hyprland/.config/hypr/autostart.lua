local mainMonitor = "DP-3"

local function after(ms, fn)
	hl.timer(fn, { timeout = ms, type = "oneshot" })
end

local function spawn(cmd, opts)
	opts = opts or {}

	local function run()
		hl.exec_cmd(cmd, opts.rules)
	end

	if opts.delay then
		after(opts.delay, run)
	else
		run()
	end
end

hl.on("hyprland.start", function()
	spawn("hyprpaper", { delay = 1000 })
	spawn("/usr/lib/polkit-kde-authentication-agent-1")
	spawn("emacs --daemon")
	spawn("gsettings set org.gnome.desktop.interface cursor-theme 'Qogir-Manjaro-cursors'")

	spawn("waterfox", {
		delay = 5000,
		rules = { workspace = "name:background silent" },
	})

	after(5000, function()
		hl.dispatch(hl.dsp.focus({ monitor = mainMonitor }))
	end)
end)
