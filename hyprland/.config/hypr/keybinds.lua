local hs = require("hyprsplit")
local mainMod = "SUPER" -- modifiers must be uppercase on Hyprland 0.56

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd('emacsclient -c -a ""'))
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd("rofi -show drun"))
hl.bind(mainMod .. " + w", hl.dsp.exec_cmd("~/.config/hypr/scripts/wallpaper.sh"))
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))

hl.bind(mainMod .. " + c", hl.dsp.window.close())
hl.bind(mainMod .. " + m", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + d", hl.dsp.window.float())

hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })

hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))

-- Up/Down mirror Right/Left so either hand can switch on a split keyboard
hl.bind(mainMod .. " + Right", hs.dsp.focus({ workspace = "r+1" }))
hl.bind(mainMod .. " + Left", hs.dsp.focus({ workspace = "r-1" }))
hl.bind(mainMod .. " + Up", hs.dsp.focus({ workspace = "r+1" }))
hl.bind(mainMod .. " + Down", hs.dsp.focus({ workspace = "r-1" }))
