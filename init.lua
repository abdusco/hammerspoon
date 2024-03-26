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