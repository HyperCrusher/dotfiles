local function spawn(cmd)
	hl.exec_cmd(cmd)
end

hl.on("hyprland.start", function()
	spawn("sleep 1 && hyprpaper")
	spawn("/usr/lib/polkit-kde-authentication-agent-1")
	spawn("sleep 5 && hyprctl dispatch exec '[workspace name: background silent] firefox'")
	spawn("gsettings set org.gnome.desktop.interface cursor-theme 'Qogir-Manjaro-cursors'")
end)
