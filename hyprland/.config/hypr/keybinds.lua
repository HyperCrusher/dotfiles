local hs = require("hyprsplit")
local mod = "SUPER"

hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd("ghostty"))
hl.bind(mod .. " + SPACE", hl.dsp.exec_cmd("rofi -show drun"))
hl.bind(mod .. " + w", hl.dsp.exec_cmd("~/.config/hypr/scripts/wallpaper.sh"))
hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))

hl.bind(mod .. " + C", hl.dsp.window.close())
hl.bind(mod .. " + M", hl.dsp.window.fullscreen())
hl.bind(mod .. " + d", hl.dsp.window.float())

hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })

hl.bind(mod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + j", hl.dsp.focus({ direction = "down" }))
hl.bind(mod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + l", hl.dsp.focus({ direction = "right" }))

hl.bind(mod .. " + right", hs.dsp.focus({ workspace = "r+1" }))
hl.bind(mod .. " + left", hs.dsp.focus({ workspace = "r-1" }))
hl.bind(mod .. " + up", hs.dsp.focus({ workspace = "r+1" }))
hl.bind(mod .. " + down", hs.dsp.focus({ workspace = "r-1" }))
