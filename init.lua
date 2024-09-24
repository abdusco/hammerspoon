require("hs.ipc")
local shell = require("shell")

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "R", function()
    hs.alert.show("Reloading config")
    hs.timer.doAfter(1, function ()
        hs.reload()
    end)
end)

local function run_python(code, ...)
    local cmd = {"/opt/homebrew/bin/python3", "-c", code}

    local args = table.pack(...)
    for i = 1, args.n do
        table.insert(cmd, tostring(args[i]))
    end

    return shell.run(cmd)
end

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "H", function()
    local code = [[

import os
import sys

for k, v in os.environ.items():
  print(f'{k}={v}')

]]

    local ok, output = run_python(code)
    if ok then
        hs.alert.show(output)
    else
        hs.alert.show("Failed to execute command: " .. output)
    end
end)


prev_percent = nil
function on_battery_changed()
    if hs.battery.isCharging() then
        return
    end

    percent = hs.battery.percentage()
    if percent ~= prev_percent and percent < 20 then
        hs.alert.show(string.format(
        "Plug-in the power, only %d%% left!!", percent))
    end

    prev_percent = percent
end

battery_watcher = hs.battery.watcher.new(on_battery_changed)
battery_watcher:start()

-- copy the location on goland and open the position on gitlab
hs.hotkey.bind({"cmd", "alt"}, "G", function()
    local window = hs.window.focusedWindow()
    local application = window and window:application()
    
    if application and application:name() == "GoLand" then
        hs.eventtap.keyStroke({"cmd", "alt", "shift"}, "C")
        hs.timer.doAfter(0.1, function()
            local clipboard = hs.pasteboard.getContents()
            gitlab_position = clipboard:gsub(":", "#L")
            local url = "https://gitlab.com/refurbed/engineering/platform/blob/master/" .. gitlab_position
            hs.urlevent.openURL(url)
            local markdown = "[" .. clipboard .. "](" .. url .. ")"
            hs.pasteboard.setContents(markdown)
        end)
    end
end)